class Game
  attr_reader :response_code, :last_guess
  attr_accessor :guess, :guess_counter, :game_number

  def initialize
    @guess_counter = 0
    @game_number = 0
    @guess_collector = []
    @guess = 0
    @last_guess = 0
    @start = false
  end

  def game_path(path, verb, guess)
    if path == "/start_game" && verb == "POST"
      start_game
    elsif @start == false
      "Gotta start a game first, buddy!"
    elsif path == "/game" && verb == "GET"
      game_info
    elsif path == "/game" && verb == "POST"
      make_a_guess(guess)
    end
  end

  def start_game
    @game_number = rand(1..100)
    @start = true
    "Good luck!"
  end

  def game_info
    if guess_counter > 0
      if @last_guess > game_number
        guess_response = "Your guess was too high!"
      elsif @last_guess < game_number
        guess_response = "Your guess was too low!"
      elsif @last_guess == game_number
        guess_response = "That is CORRECT!!"
        @start = false
      end
    end
    @response_code = "200 OK"
    "#{guess_response} with #{guess_counter} guesses!"
  end

  def make_a_guess(guess)

    @guess_counter += 1
    @last_guess = guess
    # binding.pry
    @response_code = "301 Moved Permanently"
  end

end
