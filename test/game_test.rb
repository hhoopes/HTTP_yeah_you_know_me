require 'minitest/autorun'
require 'hurley'
require_relative '../test/test_helper'
require 'game'



class GameTest < Minitest::Test

  def test_that_an_object_can_be_instantiated_in_Game_class
    gamer = Game.new

    assert_equal Game, gamer.class
  end

  def test_yo

  end

end
