require 'minitest'
require 'hurley'
require_relative '../test/test_helper'
require 'pry'
require 'request'

class RequestTest < Minitest::Test

  def test_sanity_check_server_returns_a_success_response
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_request_handler_takes_a_request_and_returns_a_string
    handler = Request.new

  end
