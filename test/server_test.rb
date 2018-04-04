require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'
require 'pry'

class ServerTest < Minitest::Test

 def test_server_exists
   server = Server.new

   assert_instance_of Server, server
 end

 def test_it_responds_to_http_requests
   server = Server.new

   refute_equal "", server.process_response("<pre>\nVerb: POST\nPath: /\n
     Protocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept:
      text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n
      </pre>")
 end

 def test_valid_HTML_response
   server = Server.new

   assert server.process_response("<pre>\nVerb: POST\nPath: /\n
     Protocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept:
      text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n
      </pre>").include? "<html>"
 end

 def test_it_returns_hello_world
   server = Server.new
   expected = "<pre>" + ("Hello, World! (#{0})\n") + "</pre>"

   assert_equal expected, server.response
 end

 def test_it_counts_server_hits
  server = Server.new

  assert_equal 0, server.server_hits
  server.process_response("")
  assert_equal 1, server.server_hits
 end

 def test_server_starts
   skip
   server = Server.new

   assert_equal "", server.start
 end
end
