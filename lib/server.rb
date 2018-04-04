require 'socket'

class Server

  attr_reader :server_hits,
              :client

  def initialize
    @server_hits = 0
  end

  def connect
    @client = tcp_server.accept
    puts "Ready for a request"
  end

  def close
    @client.close
    puts "\nResponse complete, exiting."
  end

  def lines
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
      puts "Got this request:"
      puts request_lines.inspect
      puts "Sending response."
    end
  end

  def parse(lines)
    @parsed_data = Parser.new(lines)
  end

  def start
    tcp_server = TCPServer.new(9292)
    connect
    lines
    response
    process_response(response)
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
    close
  end

  def response
    "<pre>" + ("Hello, World! (#{server_hits})\n") + "</pre>"
    # output = "<html><head></head><body>#{response}</body></html>"
  end

  def process_response(request_string)
    @server_hits += 1
     "<html><head></head><body>#{request_string}</body></html>"
  end
end

s = Server.new
s.start
