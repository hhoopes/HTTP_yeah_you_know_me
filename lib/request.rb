$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require 'pry'
require 'game'


class Request
  attr_reader :request_vars

  def initialize(request_lines, shutdown)
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
    verb = @request_vars[:verb]
    if path == "/"
      get_diagnostics
    elsif path == "/hello"
      # response = HelloWorld.new()
      hello
    elsif path == "/datetime"
      date_time
    elsif path == "/start_game" && verb == "POST"
      #send over to start_game method in Game class
      player = Game.new
      player.start_game
    elsif path == "/game" && verb == "GET"
      #send over to game_info method in Game class
      player.game_info
    elsif path == "/game" && verb == "POST"
      #send over to make_a_guess method in Game class
      player.make_a_guess
    elsif path == "/shutdown"
      shutdown
    else
      puts "path does not exist"
    end
  end

  #if path is / (root)
  def get_diagnostics
    output_diagnostics = ""
    output_diagnostics = request_vars.inject("") do |acc, element|
       acc + "#{element[0].to_s}: #{element[1]}\n"
     end
     output_diagnostics
  end

  def hello
    @iteration_number += 1
    "Hello, World!(#{@iteration_number})"
  end

  def date_time
    t = Time.now
    t.strftime("%I:%M%p on %A, %B %-d, %Y")
  end

  def shutdown
    "Total Requests: #{@requests}"
    @tcpserver.shutdown_server
  end






end
