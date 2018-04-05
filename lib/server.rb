require 'socket'
require_relative 'parser'
require 'pry'

class Server

  attr_reader :server_hits,
              :tcp_server,
              :client,
              :parsed_data

  def initialize
    @tcp_server = TCPServer.new(9292)
    @server_hits = 0
    @hello_counter = 0
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
    @parsed_data = Parser.new(lines)
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
      router
      process_response
      close
    end
  end

  def router
    puts "Sending response."
    @process_response = []
    case @parsed_data
    when @parsed_data.include?("/word_search")
      dict = File.read('/usr/share/dict/words')
      word = @parsed_data.path.split('=')[-1]
      if dict.include?(word)
        @process_response << "#{word} is a known word"
      else
        @process_response << "#{word} is not a known word"
      end
    when "/hello"
      @hello_counter += 1
      @process_response << "Hello World! (#{@hello_counter})"
    when "/datetime"
      @process_response << Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    when "/shutdown"
      @process_response << "Total Requests: #{@counter}"
    else
      @process_response << @parsed_data.diagnostics
    end
  end

  def headers
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def process_response
    output = "<html><head></head><body>#{@response.join}</body></html>"
    puts ["Wrote this response:", headers, output].join("\n")
    @client.puts headers
    @client.puts output
  end

  def output
    "<pre>" + ("Hello, World! (#{server_hits})\n") + "</pre>"
    @parsed_data.diagnostics
  end
end

s = Server.new
s.start
