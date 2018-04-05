class Parser

  attr_reader :get_response

  def initialize(get_response)
    @get_response = get_response
  end

  def get_verb
    @get_response[0].split[0]
  end

  def get_path
    @get_response[0].split[1].chars[0]
  end

  def get_protocol
    @get_response[0].split[2]
  end

  def get_host
    @get_response.find do |line|
      line.include?("Host")
    end.split(":")[1].lstrip
  end

  def get_port
    @get_response.find do |line|
      line.include?("Host")
    end.split(":")[2]
  end

  def get_accept
    @get_response.find do |line|
      line.include?("Accept")
    end.split(":")[1].lstrip
  end

  def diagnostics
    ["<pre>",
      "Verb: #{get_verb}",
      "Path: #{get_path}",
      "Protocol: #{get_protocol}",
      "Host: #{get_host}",
      "Port: #{get_port}",
      "Origin: #{get_host}",
      "Accept: #{get_accept}",
      "</pre>"].join("\n")
  end
end
