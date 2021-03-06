$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require 'pry'
require 'game'
require 'word_search'

class Request
  attr_reader :shutdown_flag, :request_vars, :requests, :hellos, :player, :response_code
  
    def initialize
    @request_vars = Hash.new
    @player = Game.new
    @searcher = WordSearch.new
    @shutdown_flag = false
    @response_code = "200 OK"
    @requests = 0
    @hellos = 0
  end

  def process(request_lines)
    formatted_request = format(request_lines)
    define_variables(formatted_request)
    dispatch_request
  end

  def format(request)
    formatted_request = []
    key_words = ["Host:", "Accept:", "HTTP/1.1", "guess"]
    request.each do |element|
        key_words.each do |key|
          formatted_request << element.split(" ") if element.include?(key)
        end
    end
    formatted_request
  end

  def define_variables(formatted_request)
    verb = formatted_request[0][0]
    path = formatted_request[0][1]
    protocol = formatted_request[0][2]
    host = formatted_request[1][1].split(":")[0]
    port = formatted_request[1][1].split(":")[1]
    origin = host
    accept = formatted_request[2][1]
    guess = define_guess(formatted_request)
    @request_vars = {verb: verb,
                    path: path,
                    protocol: protocol,
                    host: host,
                    port: port,
                    origin: origin,
                    accept: accept,
                    guess: guess
                    }
  end

  def define_guess(formatted_request)
    split_guess = formatted_request[-1].join.split("=")
     if split_guess[0] == "guess"
       guess = split_guess[1].to_i
     end
   end

  def dispatch_request
    @requests += 1
    path = request_vars[:path]
    verb = request_vars[:verb]
    guess = request_vars[:guess]
    if path == "/"
      get_diagnostics
    elsif path == "/hello"
      hello
    elsif path == "/datetime"
      date_time
    elsif path == "/start_game" || path == "/game"
      response = @player.game_path(path, verb, guess)
      @response_code = player.response_code
      response
    elsif path.include?("/word_search")
      @searcher.find_word(path)
    elsif path == "/shutdown"
      shutdown
    else
      puts "path does not exist, dawg"
    end
  end

  def get_diagnostics
    output_diagnostics = ""
    output_diagnostics = request_vars.inject("") do |acc, element|
       acc + "#{element[0].to_s}: #{element[1]}\n"
     end
     output_diagnostics
  end

  def hello
    @hellos += 1
    "Hello, World!(#{@hellos})\n\n#{get_diagnostics}"
  end

  def date_time
    t = Time.now
    time = t.strftime("%I:%M%p on %A, %B %-d, %Y")
    "#{time}\n\n#{get_diagnostics}"
  end

  def shutdown
    @shutdown_flag = true
    "Total Requests: #{@requests}\n\n#{get_diagnostics}"
  end

end
