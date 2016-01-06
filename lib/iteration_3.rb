# http://host:port/word_search?param=value&param2=value2

$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require 'socket'
require 'output_diagnostic'
require 'word_search'

iter_1 = OutputDiagnostic.new
tcp_server = TCPServer.new(9292)

loop do
  client = tcp_server.accept

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
    response = "<pre>" + iter_1.get_response(@request_lines) + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts @headers
    client.puts @output
  end

  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  puts "Sending response."
  response = "<pre>" + iter_1.get_response(request_lines) + "</pre>"
  output = "<html><head></head><body>#{response}</body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output

  puts ["Wrote this response:", headers, output].join("\n")
  client.close
  puts "\nResponse complete, exiting."
end
