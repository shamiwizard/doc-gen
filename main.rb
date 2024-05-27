require 'pathname'
require 'openai'
require 'pry'
require './open_ai_client'
require './project_struction'

root_path = '../../rails/hotwire_forum'
raise StandartError, 'Folder does not exist' unless File.directory?(root_path)
struction = ProjectStruction.new(root_path).tap { _1.display_project_structure }
puts struction.structure_output
ai_client = AiClient.new.tap { _1.get_needed_folders_and_files(struction.structure_output) }

require_files = ai_client.last_message
puts require_files
['/app/controllers/discussions_controller.rb'].each do |path|
  code = File.read("#{root_path}#{path}")
  ai_client.generate_documentation(path, code)
end

puts ai_client.last_message
