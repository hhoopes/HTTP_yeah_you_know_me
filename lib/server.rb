$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require 'socket'
require 'request'

class Server
  attr_reader :tcpserver, :request_handler, :request_lines, :output, :headers, :shutdown_flag
  attr_accessor :client

  def initialize
    @request_lines = []
    @tcpserver = TCPServer.new(9292)
    @shutdown_flag = false
    @request_handler = Request.new
  end


  def accept_request
    @request_lines = []
    while (line = client.gets) && !line.chomp.empty?
      request_lines << line.chomp
    end
    verb = request_lines[0].split(" ")[0]
    if verb == "POST"
      request_lines << get_body
    end
  end

  def get_body
    content_length = request_lines.detect{ |element| element.include?("Content-Length")}.split(":").last.to_i
    body = client.gets(content_length)
    # request_lines << body
  end

  def display_to_terminal
    puts "Got this request:"
    puts request_lines.inspect
  end

  def process_request
    response_text = request_handler.process(request_lines)
    @shutdown_flag = request_handler.shutdown_flag
    send_response(response_text)
  end


  def send_response(response_text)
    puts "Sending response."
    response = "<pre>" + "#{response_text}" + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"

    @headers = ["http/1.1 #{request_handler.response_code}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}"]
    if request_handler.response_code == "301 Moved Permanently"
      @headers << "Location: http://127.0.0.1:9292/game"
    end
    @headers << "\r\n"
    client.puts headers.join("\r\n")
    client.puts output
  end

  def write_response_to_terminal
    puts ["Wrote this response:", headers, output].join("\n")
  end

  def close_client
    client.close
    puts "\nResponse complete, exiting."
  end

  def check_and_shutdown
    tcp_server.close if shutdown?
  end

  def shutdown?
    @shutdown_flag
  end

end
