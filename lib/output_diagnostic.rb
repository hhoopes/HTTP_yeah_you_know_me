

class OutputDiagnostic

  def initialize
    # @diagnostic = Hash.new(
    #                   Verb: @request_lines[0].split(" ")[0],
    #                   Path: @request_lines[0].split(" ")[1],
    #                   Protocol: @request_lines[0].split(" ")[2],
    #                   Host: @request_lines[1].split(" ").split(":")[0],
    #                   Port: @request_lines[1].split(" ").split(":")[1],
    #                   Origin: @request_lines[1].split(" ").split(":")[0],
    #                   Accept: accept = @request_lines.find do | element|
    #                     element.include? "Accept:"
    #                   end
    #                   accept.split(" ")[1]
    #                 )
    end

    def get_response(request)
      get_diagnostics(request)
    end

    def get_diagnostics(request)
      verb = request[0].split(" ")[0]
      path = request[0].split(" ")[1]
      protocol = request[0].split(" ")[2]
      host = request[1].split(" ")[1].split(":")[0]
      port = request[1].split(" ")[1].split(":")[1]
      origin = request[1].split(" ")[1].split(":")[0]
      accept =
        request.find do |element|
          element.include?("Accept:")
        end.split(" ")[1]

      "Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{origin}\nAccept: #{accept}"
    end
end

# <pre>
# Verb: POST
# Path: /
# Protocol: HTTP/1.1
# Host: 127.0.0.1
# Port: 9292
# Origin: 127.0.0.1
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
# </pre>
#
# ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: f4620eb2-3fb8-b51b-4521-ec01c1728be9", "Accept: ​*/*​", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
#
# GET / HTTP/1.1
# Host: 127.0.0.1:9292
# Connection: keep-alive
# Cache-Control: no-cache
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
# Postman-Token: c8c8f7f1-a6ca-2b02-34bf-efe74dc44438
# Accept: */*
# Accept-Encoding: gzip, deflate, sdch
# Accept-Language: en-US,en;q=0.8
