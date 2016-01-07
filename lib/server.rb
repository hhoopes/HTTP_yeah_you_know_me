require 'socket'
require 'request'

class Server
  attr_reader  :tcpserver, :request_handler, :output, :headers, :shutdown, :request_lines
  attr_accessor :client

  def initialize
    @request_lines = []
    @tcpserver = TCPServer.new(9292)
    @shutdown_flag = false
    @request_handler = Request.new
  end


  def accept_request
    @request_lines = []
    puts "Ready for a request"
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
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
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
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
