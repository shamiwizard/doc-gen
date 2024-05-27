# Define your OpenAI API key

class AiClient
  attr_reader :last_message

  API_KEY = ""

  def initialize
    @client = OpenAI::Client.new(access_token: AiClient::API_KEY)
  end

  def get_needed_folders_and_files(file_structure)
    prompt = <<-TEXT
    Given the following file structure:\n#{file_structure}\n\n
    Provide a minimum list of needed files to generate simple and humen like documentation base on code in these files.
    Response must containe only name of needed files.
    Exemple:
    foler/file_1.rb, file2.rb, app/models/user.rbx
    TEXT

    # Send prompt to GPT-3
    response = client.chat(
      parameters: {
          model: "gpt-4", # Required.
          messages: [{ role: "user", content: prompt}], # Required.
          temperature: 0.5,
      })

    # Extract needed folders and files from GPT-3 response
    @last_message = needed_folders_and_files = response.dig("choices", 0, "message", "content").strip.split("\n")
  end

  def generate_documentation(file_name, code)
    prompt = <<-TEXT
    Given the following code from file #{file_name}:\n#{code}\n\n
    Generate humen like documentation base on the code send to you with all formats.
    Documentation mast contain all details base on the contditions, class, features, flippers.
    TEXT

    # Send prompt to GPT-3
    response = client.chat(
      parameters: {
          model: "gpt-4", # Required.
          messages: [
            { role: 'system', content: 'Act as a product owner of the project which gona describe have his app works' },
            { role: "user", content: prompt }
          ], # Required.
          temperature: 0.5,
      })

    # Extract needed folders and files from GPT-3 response
    @last_message = needed_folders_and_files = response.dig("choices", 0, "message", "content").strip.split("\n")
  end

  private

  attr_reader :client
end



# Get needed folders and files from GPT-3


# # Print the result
# puts "Needed folders and files:"
# needed_folders_and_files.each do |item|
#   puts item
# end
