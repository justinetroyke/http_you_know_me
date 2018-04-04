require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'
require 'rubygems'
require 'pry'

class ParserTest < Minitest::Test

  def test_it_exists
    parser = Parser.new(lines)

    assert_instance_of Parser, parser
  end

  def test_it_gets_verb
    parser = Parser.new

    assert_equal "", parser.get_verb
  end
end
