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
    request = ["GET /hello HTTP/1.1", "User-Agent: Hurley v0.2", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    response = handler.process(request)
    expected = "Hello, World!(#{handler.hellos})\n\n#{handler.get_diagnostics}"

    assert_equal expected, response
  end

  def test_request_handler_stores_correct_verbs_for_requests
    handler = Request.new
    handler2 = Request.new

    request = ["GET /hello HTTP/1.1", "User-Agent: Hurley v0.2", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    response = handler.process(request)
    assert_equal "GET", handler.request_vars[:verb]

    request2 = ["POST /start_game HTTP/1.1", "User-Agent: Hurley v0.2", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    response2 = handler2.process(request2)
    assert_equal "POST", handler2.request_vars[:verb]
  end

  def test_shutdown_path_refutes_server_success
    skip
    first_try = Hurley.get("http://127.0.0.1:9292/hello")
    shutdown = Hurley.get("http://127.0.0.1:9292/shutdown")
    second_try = Hurley.get("http://127.0.0.1:9292/hello")

    assert first_try.success?
    assert_equal "true", shutdown.shutdown_flag
    refute second_try.success?

    `ruby start_server.rb`
  end

  def test_request_handler_receives_new_response_code_on_redirect_and_redirects
    skip
    Hurley.get("http://127.0.0.1:9292/start_game")
    response = Hurley.post("http://127.0.0.1:9292/game", :guess => 22)

    assert response.redirection?
  end


end
