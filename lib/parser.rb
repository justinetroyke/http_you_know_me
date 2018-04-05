class Parser

  attr_reader :get_response

  def initialize(get_response)
    @get_response = get_response
  end

  def get_verb
    @get_response[0].split[0]
  end

  def get_path
    @get_response[0].split[1].split[0]
  end
end
