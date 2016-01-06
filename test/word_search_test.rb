require 'minitest'
require 'hurley'
require_relative '../test/test_helper'
require 'word_search'
require 'pry'

class WordSearch < Minitest::Test
  attr_reader :client

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_server_returns_a_success_response
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_word_search_extracts_correct_word_from_request
    skip
    search = WordSearch.new
    word = client.get "word_search?param=pizza" do |request|
      search.get_word(request.url)
    end

    assert_equal "pizza", word
  end

  def test_word_search_identifies_known_word_from_param
    skip
    search = WordSearch.new
    word = client.get "word_search?param=calzone" do |request|
      search.get_word(request.url)
    end

    assert search(word).known_word?
  end

  def test_word_search_server_responds_to_known_word
    skip
    search = WordSearch.new
    body = client.get "word_search?param=calzone" do |response|
      response.body
    end

    assert_equal "<html><head></head><body>WORD is a known word</body></html>", body
  end

  def test_word_search_server_responds_to_unknown_word
    skip
    search = WordSearch.new
    body = client.get "word_search?param=calzone" do |response|
      response.body
    end
    assert_equal "<html><head></head><body>WORD is an unknown word</body></html>", body
  end
end
# response = client.get "" do |req|
#   req.url
# end
# "" represents webpage you're trying to get after root
