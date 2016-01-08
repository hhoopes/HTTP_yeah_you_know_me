require 'minitest/autorun'
require 'hurley'
require_relative '../test/test_helper'
require 'game'



class GameTest < Minitest::Test

  def test_that_an_object_can_be_instantiated_in_Game_class
    gamer = Game.new

    assert_equal Game, gamer.class
  end

  def test_you_cant_make_a_guess_without_starting_a_game
    gamer = Game.new
    gamer.guess = 5

    assert_equal "Gotta start a game first, buddy!",
       gamer.game_path("/game", "POST", gamer.guess)
  end

  def test_can_accept_a_low_number_once_the_game_has_been_started
    gamer = Game.new
    gamer.guess = 0
    gamer.guess_counter = 1
    gamer.start_game

    assert_equal "Your guess was too low! with 1 guesses!",
                  gamer.game_path("/game", "GET", gamer.guess)
  end

  def test_can_accept_a_high_number_once_the_game_has_been_started
    gamer = Game.new
    gamer.guess = 101
    gamer.guess_counter = 1
    gamer.start_game
    gamer.last_guess = 101

    assert_equal "Your guess was too high! with 1 guesses!",
                  gamer.game_path("/game", "GET", gamer.guess)
  end

  def test_can_accept_the_correct_answer_once_the_game_has_been_started
    gamer = Game.new
    gamer.guess = 5
    gamer.guess_counter = 1
    gamer.start_game
    gamer.last_guess = 5
    gamer.game_number = 5

    assert_equal "That is CORRECT!! with 1 guesses!",
                  gamer.game_path("/game", "GET", gamer.guess)
  end

end
