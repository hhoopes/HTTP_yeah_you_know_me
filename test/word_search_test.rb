require 'minitest'
require 'hurley'
require_relative '../test/test_helper'
require 'word_search'
require 'pry'

class WordSearchTest < Minitest::Test
  
  def test_server_returns_a_success_response
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_word_search_extracts_correct_word_from_request
    search = WordSearch.new
    response = Hurley.get("http://127.0.0.1:9292/word_search?param=pizza")

    assert "pizza", search.word
  end

  def test_entire_dictionary_gets_populated
    search = WordSearch.new
    length = File.read('/usr/share/dict/words').length

    assert_equal length, search.dictionary.length
  end

  def test_word_search_server_responds_to_known_word
    response = Hurley.get("http://127.0.0.1:9292/word_search?param=pizza")

    assert_equal "<html><head></head><body><pre>pizza is a known word!</pre></body></html>", response.body
  end

  def test_word_search_server_responds_to_unknown_word
    response = Hurley.get("http://127.0.0.1:9292/word_search?param=calzone")

    assert_equal "<html><head></head><body><pre>calzone is NOT a known word!</pre></body></html>", response.body
  end

  def test_word_search_word_can_start_with_capital_letter
    response = Hurley.get("http://127.0.0.1:9292/word_search?param=Domino")

    assert_equal "<html><head></head><body><pre>Domino is a known word!</pre></body></html>", response.body
  end

  def test_word_search_word_can_be_all_capital_letters
    response = Hurley.get("http://127.0.0.1:9292/word_search?param=PIZZA")

    assert_equal "<html><head></head><body><pre>PIZZA is a known word!</pre></body></html>", response.body
  end

end
