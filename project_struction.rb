class ProjectStruction
  attr_accessor :root_path
  attr_reader :structure_output

  SKIP = %W[
    test.rb
    cable.yml
    boot.rb
    puma.rb
    environment.rb
    production.rb
    storage.yml
    application.rb
    boot
    tmp
    .git
    log
    .ruby-lsp
    public
    test
    bin
    github.pub
    environment
    db
    initializers
    database.yml
    importmap.rb
    Gemfile.lock
  ]

  def initialize(root_path)
    @root_path = root_path
  end

  def display_project_structure
    @structure_output = "Project Structure:\n#{root_path}\n"
    @structure_output += get_directory_structure(root_path, 0)
    @structure_output
  end

  private

  def get_directory_structure(directory, indent_level)
    @structure_output = ''

    Dir.foreach(directory) do |entry|
      next if SKIP.include?(File.basename(entry))
      next if entry == '.' || entry == '..'

      entry_path = File.join(directory, entry)
      indentation = '  ' * indent_level

      if File.directory?(entry_path)
        @structure_output += "#{indentation}#{entry}/\n"
        @structure_output += get_directory_structure(entry_path, indent_level + 1)
      else
        @structure_output += "#{indentation}#{entry}\n"
      end
    end

    @structure_output
  end
end
