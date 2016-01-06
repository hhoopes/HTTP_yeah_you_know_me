$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require 'socket'
require 'request'

class Server
  attr_reader  :tcpserver, :request_handler
  attr_accessor  :request, :request_lines, :output, :headers, :shutdown

  def initialize
    @request_lines = []
    @output = ""
    @headers = []
    @tcpserver = TCPServer.new(9292)
    @shutdown = false
  end


  def ready_for_request
    @request_lines = []
    puts "Ready for a request"
    while line = request.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def display_to_terminal
    puts "Got this request:"
    puts request_lines.inspect
  end

  def get_response
    request_handler = Request.new(request_lines, shutdown)
  end

  def send_response
    puts "Sending response."
    response = "<pre>" + "#{get_response}" + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    request.puts @headers
    request.puts @output
  end

  def write_response
    puts ["Wrote this response:", @headers, @output].join("\n")
  end

  def close_client
    request.close
    puts "\nResponse complete, exiting."
    shutdown_server if shutdown?
  end

  def shutdown_server
    tcp_server.close
  end

  def shutdown?
    @shutdown
  end

end


  iter_1 = Server.new
loop do
  iter_1.request = iter_1.tcpserver.accept
  iter_1.ready_for_request

  # iter_1.get_request

  iter_1.send_response

  iter_1.write_response

  iter_1.close_client
end
