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
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and invalid auth credentials' do
      before(:each) do
        authorize 'notauser', 'badpass'
        post 'update', :params => valid_json
      end

      it { expect(last_response.status).to eq 401 }
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and valid auth credentials' do
      before(:each) do
        authorize valid_user.username, 'testing'
        post 'update', valid_json
      end

      it { expect(last_response.status).to eq 200 }
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
    it { expect(last_response.body).to eq 'Unprocessable JSON entity' }
  end
end



__END__

  let!(:foo_sitewide_counter) { FactoryBot.create(:sitewide_counter, :name => 'foo', :ipv4_preload => 42) }
  let!(:bar_counter) { FactoryBot.create(:counter_with_hits, :name => 'bar') }

  describe 'when getting a nonexistent Counter' do

    before(:each) do
      get '/counters/baz'
    end

    it { expect(last_response.status).to eq 404 }
    it { expect(last_response.body).to be_empty }
  end

  describe 'when getting a regular Counter' do

    before(:each) do
      get '/counters/bar'
    end

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000003');" }
  end

  describe 'when getting a regular Counter IPv6 count' do

    before(:each) do
      get '/counters/bar?ipv6=true'
    end

    it { expect(last_response.status).to eq 200 }

    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000003 (000001 on IPv6)');" }
  end

  describe 'when getting a Sitewide Counter' do

    before(:each) do
      get '/counters/foo'
    end

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000045');" }
  end
end