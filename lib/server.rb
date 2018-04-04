require 'socket'

class Server

  attr_reader :server_hits

  def initialize
    @server_hits = 0
  end

  def server
    tcp_server = TCPServer.new(9292)


    while tcp_server do
      client = tcp_server.accept

      puts "Ready for a request"
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"

      puts request_lines.inspect

      puts "Sending response."

      output = "<html><head></head><body>#{response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      puts ["Wrote this response:", headers, output].join("\n")
      client.close
      puts "\nResponse complete, exiting."
    end
  end

  def response
    "<pre>" + ("Hello, World! (#{server_hits})\n") + "</pre>"
  end

  def process_response(request_string)
    @server_hits += 1
     "<html><head></head><body>#{request_string}</body></html>"
  end
end
