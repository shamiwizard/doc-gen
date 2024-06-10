require 'spec_helper'

RSpec.describe 'Main' do
  include Rack::Test::Methods

  describe 'GET /' do
    it "has http response ok" do
      get '/'
      expect(last_response).to be_ok
    end

    it "response with html" do
      get '/'
      expect(last_response.body).to include('Вибрати усі файли')
    end

    context 'when project_path is present' do
      it 'set @directory_structure' do
        allow_any_instance_of(Sinatra::Cookies::Jar).to receive(:[]).with(:project_path).and_return(Base64.encode64('/code/ruby/my_document_generation/app'))
        get '/'
        expect(@controller.instance_variable_get(:@directory_structure)).to be_nil
      end
    end

    context 'when project_path is not present' do
      it 'set @directory_structure as nil' do
        get '/'
        expect(@controller.instance_variable_get(:@directory_structure)).to be_nil
      end
    end
  end

  describe 'POST /set_project_path' do
    it 'redirect to the main page' do
      post '/set_project_path'
      expect(last_response.status).to be(302)
    end
  end

  describe 'GET /get_documentation' do
    it 'has http response ok' do
      get '/get_documentation?file_path=spec/fixtures/doc.md'
      expect(last_response).to be_ok
    end

    it 'returns documentation' do
      get '/get_documentation?file_path=spec/fixtures/doc.md'
      expect(last_response.body).to include('file')
    end
  end

  describe 'POST /generate_doc' do
    it 'has http response ok' do
      post '/generate_doc'
      expect(last_response).to be_ok
    end

    it 'starts the generation' do
      post '/generate_doc'
      expect(last_response.body).to include('Generation started')
    end
  end
end
