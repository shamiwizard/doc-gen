require 'sinatra'
require "sinatra/reloader"
require "sinatra/cookies"
require "sinatra/json"
require "base64"
require 'fileutils'
require "openai"
require 'faye/websocket'
require_relative 'services/open_ai_client'
require_relative 'services/helpers'
require_relative 'services/generate_doc'

include Helpers

set :public_folder, 'public'
set :erb, layout: :'/layout/layout'
set :socket, nil

post '/set_project_path' do
  cookies[:project_path] = Base64.encode64(params['project_path']) if params['project_path']

  redirect('/')
end

get '/' do
  project_name

  if params['doc_file_path']
    @hash = { doc: File.read(params['doc_file_path']), doc_file_path: params['doc_file_path']}.to_json
  end

  @directory_structure = list_directory(project_path) if project_path
  erb :index
end

get '/get_documentation' do
  doc_file_path = "#{project_path}/documentation#{params['code_file_path'].sub(project_path, '')}".sub(File.extname(params['code_file_path']), '.md')
  doc = File.exist?(doc_file_path) ? File.read(doc_file_path) : nil
  json doc:, doc_file_path:, code_file_path: params['code_file_path']
end

post '/generate_doc' do
  files = JSON.parse(request.body.read)
  GenerateDoc.new(files, project_path, settings.socket).run_doc_generation
  erb :generate_doc
end

post '/edit_doc' do
  doc = params['doc']
  code_file_path = params['code_file_path']
  doc_file_path = params['doc_file_path']
  p code_file_path
  if doc.match?(/<>>Prompt:([\w\W]+)<<>/)
    prompt = doc.match(/<>>Prompt:([\w\W]+)<<>/).to_s
    doc = doc.gsub(/<>>Prompt:([\w\W]+)<<>/, '')
    doc = GenerateDoc.new([code_file_path], project_path, settings.socket).run_edit_doc(doc, prompt)
  end
  File.write(doc_file_path, doc)

  redirect("/?doc_file_path=#{doc_file_path}")
end

get '/websocket' do
  if !Faye::WebSocket.websocket?(request.env)
    status 400
    body 'WebSocket requests only'
  else
    ws = Faye::WebSocket.new(request.env)

    ws.on :open do |event|
      p [:open]
      settings.socket = ws
    end

    ws.on :close do
      p [:close]
    end

    ws.rack_response
  end
end

def project_path
  @project_path ||= Base64.decode64(cookies[:project_path]) if cookies[:project_path]
end

def project_name
  @project_name = project_path.split('/').last if project_path
end
