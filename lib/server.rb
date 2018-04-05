require 'socket'

class Server

  attr_reader :server_hits,
              :tcp_server,
              :client,
              :parsed_data

  def initialize
    @tcp_server = TCPServer.new(9292)
    @server_hits = 0
  end

  def connect
    @client = tcp_server.accept
    puts "Ready for a request"
  end

  def lines
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def parse(lines)
    @parsed_data = Parser.new(lines).diagnostics
    puts "Got this request:"
    puts request_lines.inspect
  end

  def close
    @client.close
  end

  def add_hit
    @server_hits += 1
  end

  def start
    loop do
      connect
      lines
      add_hit
      route

      close
    end
  end

  def router
    puts "Sending response."
    @process_response = []
    case @parsed_data
    when @parsed_data.include?("/word_search")


    puts ["Wrote this response:", process_response(output)].join("\n")
  end
  def output
    "<pre>" + ("Hello, World! (#{server_hits})\n") + "</pre>"
    @parsed_data
  end

  def process_response

    puts ["Wrote this response:", process_response(output)].join("\n")
  end

  def client_response(headers)
    puts headers
    output = "<html><head></head><body>#{@response.join}</body></html>"
    puts output
    puts ["Wrote this response:", headers].join("\n")
  end

  def headers
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")]
  end
end

s = Server.new
s.start
