require 'minitest'
require 'hurley'
require_relative '../test/test_helper'
require 'pry'
require 'request'

class HelloWorldTest < Minitest::Test

  def test_server_returns_a_success_response
    response = Hurley.get("http://127.0.0.1:9292/")
    assert response.success?
  end

  def test_server_returns_hello_world_message
    response = Hurley.get("http://127.0.0.1:9292/hello")

    assert response.body.include?("Hello, World!")
  end

  def test_server_returns_formatted_number_of_iterations
    response = Hurley.get("http://127.0.0.1:9292/hello")

    assert response.body.scan(/\([0-9]+\)/)
  end

end
