require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'
require './lib/parser'
require 'pry'

class ParserTest < Minitest::Test

  GET_RESPONSE = [ "GET /favicon.ico HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36",
                  "Accept: image/webp,image/apng,image/*,*/*;q=0.8"]

  def test_it_exists
    parser = Parser.new(GET_RESPONSE)

    assert_instance_of Parser, parser
  end

  def test_it_gets_verb
    parser = Parser.new(GET_RESPONSE)

    assert_equal "GET", parser.get_verb
  end

  def test_it_gets_path
    parser = Parser.new(GET_RESPONSE)

    assert_equal "/", parser.get_path
  end

  def test_it_gets_protocol
    parser = Parser.new(GET_RESPONSE)

    assert_equal "HTTP/1.1", parser.get_protocol
  end

  def test_it_gets_host
    parser = Parser.new(GET_RESPONSE)

    assert_equal "127.0.0.1", parser.get_host
  end
end
