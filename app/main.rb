require 'sinatra'
require "sinatra/reloader"
require "sinatra/cookies"
require "sinatra/json"
require "base64"
require './app/services/open_ai_client.rb'

set :public_folder, 'public'
set :erb, layout: :'/layout/layout'

def list_directory(path)
  directories = []
  files = []
  full_path = ''

  Dir.foreach(path) do |item|
    next if item == '.' || item == '..'

    full_path = File.join(path, item)
    if File.directory?(full_path)
      directories << item
    else
      files << item
    end
  end

  directories.sort!
  files.sort!

  return '' if files.size < 1

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
    result += "<div class='list-group-item file' data-file-path='#{path}/#{file}'><i class='bi bi-file-earmark'></i> #{file} <button class='btn float-end add-file'><i class='bi bi-plus'></i></button></div>"
  end

  result += "</div>"

  result
end

post '/set_project_path' do
  cookies[:project_path] = Base64.encode64(params['project_path']) if params['project_path']
  redirect('/')
end

get '/' do
  project_name
  @directory_structure = list_directory(project_path) if project_path
  erb :index
end

get '/get_documentation' do
  file = File.read(params['file_path'])
  json file: file
end

post '/generate_doc' do
  body = JSON.parse(request.body.read)
  process_generation
  text 'Generation started'
end

def project_path
  @project_path ||= Base64.decode64(cookies[:project_path]) if cookies[:project_path]
end

def project_name
  @project_name = project_path.split('/').last if project_path
end

def process_generation
  p 'Start processing'
end
