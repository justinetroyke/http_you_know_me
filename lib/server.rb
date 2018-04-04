require 'socket'

class Server

  attr_reader :server_hits,
              :tcp_server,
              :client

  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @server_hits = 0
    @line = []
    @client = 'disconnected'
  end

  def connect
    @client = tcp_server.accept
    binding.pry
  end

  def close
    client.close
    puts "\nResponse complete, exiting."
  end

  def request_lines
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def start
    connect
    request_lines
    while tcp_server do
      puts "Ready for a request"
      puts "Got this request:"
      puts request_lines.inspect
      puts "Sending response."
      response
      output = "<html><head></head><body>#{response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      puts ["Wrote this response:", headers, output].join("\n")
    end
    close
  end

  def response
    "<pre>" + ("Hello, World! (#{server_hits})\n") + "</pre>"
  end

  def process_response(request_string)
    @server_hits += 1
     "<html><head></head><body>#{request_string}</body></html>"
  end
end
