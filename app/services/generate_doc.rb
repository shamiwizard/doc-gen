class GenerateDoc
  attr_accessor :files, :project_path, :socket

  def initialize(files, project_path, socket)
    @files = files
    @project_path = project_path
    @socket = socket
  end

  def run_doc_generation
    Thread.new(files, project_path) do |files, project_path|
      ai_client = AiClient.new
      files.each_with_index do |file, index|
        time = Time.now
        code = File.read(file)
        doc = ai_client.generate_documentation(file, code)

        documentation_path = "#{project_path}/documentation#{file.sub(project_path, '')}".sub(File.extname(file), '.md')
        FileUtils.mkdir_p(File.dirname(documentation_path))
        # testing porposes
        doc ||= File.read("#{project_path}/documentation#{file.sub(project_path, '')}".sub(File.extname(file), '.md'))

        File.open(documentation_path, 'w+') do |f|
          f.write(doc)
        end

        notify({ total: files.size, counter: index + 1 }.to_json)
        puts "Doc generation finished: #{file}; Files number: #{files.size}; Symbol Number: #{code.size}; Time of work: #{((Time.now - time) / 60).round(3)}"
      end
    end
  end

  def run_edit_doc(doc, prompt)
    ai_client = AiClient.new
    code_file_path = files.first
    code = File.read(code_file_path)
    ai_client.edit_doc(code_file_path:, code:, doc:, edit_prompt: prompt)
  end

  private

  def notify(text)
    socket.send(text)
  end
end
