

class Request

  def initialize
    @iteration_number = 0
    @requests = 0
    @request_vars = Hash.new
  end

  def format_request(request)
    formatted_request = []
    key_words = ["Host:", "Accept:", "HTTP/1.1"]
    request.each do |element|
        key_words.each do |key|
          formatted_request << element.split(" ") if element.include?(key)
        end
    end
    define_variables(formatted_request)
  end

  def define_variables(request)
    verb = request[0][0]
    path = request[0][1]
    protocol = request[0][2]
    host = request[1][1].split(":")[0]
    port = request[1][1].split(":")[1]
    origin = host
    accept = request[2][1]
    @request_vars = {verb: verb, path: path, protocol: protocol, host: host, port: port,
                     origin: origin, accept: accept}
    match_request
  end


  def match_request
    @requests += 1
    path = @request_vars[:path]
    if path == "/"
      get_diagnostics
    elsif path == "/hello"
      # response = HelloWorld.new()
      hello
    elsif path == "/datetime"
      date_time
    elsif path == "/shutdown"
      shutdown
    else
      puts "path does not exist"
    end
  end

  #if path is / (root)
  def get_diagnostics
    @request_vars.to_s
    # "Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{origin}\nAccept: #{accept}"
  end

  #if path is /hello
  def hello
    @iteration_number += 1
    "Hello, World!(#{@iteration_number})"
  end

  #if path is /datetime
  def date_time
    t = Time.now
    t.strftime("%I:%M%p on %A, %B %-d, %Y")
  end

  #if path is /shutdown
  def shutdown
    "Total Requests: #{@requests}"
    tcp_server.close
  end






end
