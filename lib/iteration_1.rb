require 'socket'
require_relative 'output_diagnostic'

class Iteration_1
  attr_reader :client
  attr_accessor :request_lines

  def initialize
    @request_lines = []
    @output = ""
    @headers = []
    @client = TCPServer.new(9292)
  end

  def ready_for_request
    client.accept 
    puts "Ready for a request"
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def get_request
    puts "Got this request:"
    puts request_lines.inspect
  end

  def send_response
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts @headers
    client.puts @output
  end

  def write_response
    puts ["Wrote this response:", @headers, @output].join("\n")
  end

  def close_client
    client.close
    puts "\nResponse complete, exiting."
  end

end

  iter_1 = Iteration_1.new

  iter_1.ready_for_request

  iter_1.get_request

  iter_1.send_response

  iter_1.write_response

  iter_1.close_client
