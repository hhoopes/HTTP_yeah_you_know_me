

class Request

  def initialize
    @iteration_number = 0
    @requests = 0
  end

  def format_request(request)
    formatted_request = []
    key_words = []
  end

  def match_request(request)
    @requests += 1
    path = request[0].split(" ")[1]
    if path == "/"
      get_diagnostics(request)
    elsif path == "/hello"
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

  #if path is /hello
  def hello
    "Hello, World!(#{@iteration_number})"
    @iteration_number += 1
  end

  #if path is /datetime
  def date_time
    t = Time.now
    t.strftime("%I:%M%p on %A, %B %-d, %Y")
  end

  #if path is /shutdown
  def shutdown
    "Total Requests: #{@requests}"
    #shut down the server
  end






end
