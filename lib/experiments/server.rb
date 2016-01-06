require 'socket'
require './output_diagnostic'

class Server
  attr_reader  :tcpserver
  attr_accessor :request, :request_lines, :output, :headers

  def initialize
    @request_lines = []
    @output = ""
    @headers = []
    @tcpserver = TCPServer.new(9292)
    # @request = tcpserver.accept
  end


  def ready_for_request
    @request_lines = []
    puts "Ready for a request"
    while line = request.gets and !line.chomp.empty?
      request_lines << line.chomp

    end
  end

  # def pick_iteration(request_lines)

  def get_request

    puts "Got this request:"
    puts request_lines.inspect
  end

  def send_response
    diagnostic = OutputDiagnostic.new
    puts "Sending response."
    response = "<pre>" + diagnostic.get_response(@request_lines) + "</pre>"
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

  end
end


  iter_1 = Server.new
loop do
  iter_1.request = iter_1.tcpserver.accept
  iter_1.ready_for_request

  iter_1.get_request

  iter_1.send_response

  iter_1.write_response

  iter_1.close_client
end
