require 'spec_helper'
require 'rack/test'

RSpec.describe 'Update record', :type => :feature do
  include Rack::Test::Methods

  def app
    DynamicDns
  end

  let!(:valid_user) { FactoryBot.create(:user) }

  describe 'with valid JSON' do
    let(:valid_json) { '{"name":"foo.example.com","a":"1.2.3.5","aaaa":"2001:db8::2"}' }

    describe 'but no auth credentials' do 
      before(:each) do
        post 'update', :params => valid_json
      end

      it { expect(last_response.status).to eq 401 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and invalid auth credentials' do
      before(:each) do
        authorize 'notauser', 'badpass'
        post 'update', :params => valid_json
      end

      it { expect(last_response.status).to eq 401 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and valid auth credentials' do
      before(:each) do
        authorize valid_user.username, 'testing'
        post 'update', valid_json, 'CONTENT_TYPE' => 'application/json'
      end

      it { expect(last_response.status).to eq 200 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to eq 'Success' }
      it { expect(ARecord.count).to eq 1 }
      it { expect(ARecord.first.data).to eq '1.2.3.5' }
      it { expect(ARecord.first.user).to eq valid_user }
      it { expect(AAAARecord.count).to eq 1 }
      it { expect(AAAARecord.first.data).to eq '2001:db8::2' }
      it { expect(AAAARecord.first.user).to eq valid_user }
    end
  end

  describe 'with invalid JSON' do
    before(:each) do
      authorize valid_user.username, 'testing'
      post 'update'
    end

    it { expect(last_response.status).to eq 422 }
    it { expect(last_response.content_type).to start_with 'text/plain' }
    it { expect(last_response.body).to eq 'Unprocessable JSON entity' }
  end
end
