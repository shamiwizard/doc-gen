class Response
  attr_reader :save_file_name

  def initialize(save_file_name = 'response.txt')
    @save_file_name
  end

  def save_to_file(text)
    File.open(save_file_name, "w") do |file|
      responses.each do |response|
          file.puts(response)
      end
    end
  end

  def read_from_file
    File.read(save_file_name)
  end
end
