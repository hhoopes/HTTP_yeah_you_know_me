

class Game
  attr_accessor :guess, :guess_counter, :game_number

  def initialize
    @guess_counter = 0
    @game_number = 0
    @guess_collector = []
    @guess = 0
  end

  def game_path(path, verb)
    if path == "/start_game" && verb == "POST"
      start_game
    elsif path == "/game" && verb == "GET"
      game_info
    elsif path == "/game" && verb == "POST"
      make_a_guess
    end
  end

  #if it's a POST request and the path is /start_game
    #return "Good luck!" and start game
    def start_game
      @game_number = rand(1..100)
      "Good luck!"
    end

  #if it's a GET request and the path is /game
    #display @guess_counter
    #if @guess_counter > 0
      #says whether the guess was too high, too low or correct
    def game_info
      if guess_counter > 0
        if guess > game_number
          guess_response = "Your guess was too high!"
        elsif guess < game_number
          guess_response = "Your guess was too low!"
        elsif guess == game_number
          guess_response = "That is CORRECT!!"
        end
      end
      "#{guess_response} with #{guess_counter} guesses!"
    end

  #if it's a POST request and the path is /game
    #@guess_counter += 1
    #param = guess
    #guess is stored
    #player is redirected to the GET /game path
    def make_a_guess
      @guess_counter += 1
      #guess = param
      @guess_collector << guess
      game_info
    end

end
