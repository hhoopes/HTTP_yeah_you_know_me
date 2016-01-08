require 'minitest'
require 'hurley'
require_relative '../test/test_helper'
require 'pry'
require 'request'

class HelloWorldTest < Minitest::Test
  attr_reader :client

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_server_returns_a_success_response
    response = Hurley.get("http://127.0.0.1:9292/hello")
    assert response.success?
  end

  def test_server_returns_hello_world_message
    response = Hurley.get("http://127.0.0.1:9292/hello")

    assert response.body.include?("Hello, World!(2)")
  end

  def test_server_returns_number_of_iterations
    response = Hurley.get("http://127.0.0.1:9292/hello")

    assert_match /([0-9])+/, response.body
  end

end

# response = client.get "" do |req|
#   req.url
# end
# "" represents webpage you're trying to get after root
