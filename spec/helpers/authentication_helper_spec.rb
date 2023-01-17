require 'spec_helper'

class TestAuthHelper
  include Sinatra::AuthenticationHelper

  attr_accessor :headers, :status_code, :status_message

  def initialize
    @headers = {}
  end

  def halt(code, message)
    @status_code = code
    @status_message = message
  end
end

RSpec.describe 'AuthenticationHelper' do
  let(:auth_helper) { TestAuthHelper.new }
  let(:basic_auth) { mock('BasicAuth') }

  before(:each) do
    auth_helper.stubs(:get_basic_auth).returns(basic_auth)
  end

  context 'when no basic auth data is provided' do
    before(:each) do
      basic_auth.expects(:provided?).returns(false)
      auth_helper.authenticate!
    end

    it { expect(auth_helper.status_code).to eq 401 }
    it { expect(auth_helper.status_message).to eq "Not authorized\n" }
    it { expect(auth_helper.headers['WWW-Authenticate']).to eq 'Basic realm="Restricted Area"' }
  end

  context 'when basic auth data is provided' do
    let(:username) { 'testuser' }
    let(:password) { 'testpassword' }
    let(:credentials) { [username, password] }
    let(:mock_user) { mock('User') }

    before(:each) do
      basic_auth.stubs(:provided?).returns(true)
      basic_auth.stubs(:basic?).returns(true)
      basic_auth.stubs(:credentials).returns(credentials)
      basic_auth.stubs(:username).returns(username)
    end

    context 'when an invalid username is supplied' do
      before(:each) do
        auth_helper.stubs(:find_user_by_username).returns(nil)
        auth_helper.authenticate!
      end

      it { expect(auth_helper.status_code).to eq 401 }
      it { expect(auth_helper.status_message).to eq "Not authorized\n" }
      it { expect(auth_helper.headers['WWW-Authenticate']).to eq 'Basic realm="Restricted Area"' }
    end

    context 'when a valid username is supplied' do
      before(:each) do
        auth_helper.stubs(:find_user_by_username).with(username).returns(mock_user)
      end

      it 'returns the user when a valid password is supplied' do
        mock_user.expects(:authenticate).with(password).returns(true)
        expect(auth_helper.authenticate!).to eq mock_user
      end

      context 'when an invalid password is supplied' do
        before(:each) do
          mock_user.stubs(:authenticate).returns(false)
          auth_helper.authenticate!
        end

        it { expect(auth_helper.status_code).to eq 401 }
        it { expect(auth_helper.status_message).to eq "Not authorized\n" }
        it { expect(auth_helper.headers['WWW-Authenticate']).to eq 'Basic realm="Restricted Area"' }
      end
    end   
  end
end