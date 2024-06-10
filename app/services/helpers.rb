module Helpers
  def list_directory(path)
    directories = []
    files = []
    full_path = ''

    Dir.foreach(path) do |item|
      next if item == '.' || item == '..' || item[0] == '.'

      full_path = File.join(path, item)
      if File.directory?(full_path)
        directories << item
      else
        files << item
      end
    end

    directories.sort!
    files.sort!

    return '' if files.size < 1 && directories.size < 1

    result = "<div class='list-group'>"
    directories.each do |dir|
      temp = list_directory(File.join(path, dir))
      next if temp.empty?
      result += "<div class='list-group-item folder'><b><i class='bi bi-folder'></i> #{dir}/</b><button class='btn float-end add-folder'><i class='bi bi-plus'></i></button>"
      result += "<div class='list-group'>"
      result += temp
      result += "</div></div>"
    end
    files.each do |file|
      doc_exist = File.exist?("#{project_path}/documentation" + ("#{path}/#{file.sub(File.extname(file), '.md')}".sub(project_path, '')))
      result += "<div class='list-group-item file #{doc_exist ? 'has-doc' : ''}' data-file-path='#{path}/#{file}'><i class='bi bi-file-earmark'></i> #{file} <button class='btn float-end add-file'><i class='bi bi-plus'></i></button></div>"
    end

    result += "</div>"

    result
  end
end
