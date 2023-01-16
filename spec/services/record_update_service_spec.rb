require 'spec_helper'

RSpec.describe 'RecordUpdateService' do
  let(:service) { RecordUpdateService.new }

  describe 'with invalid JSON data' do
    let(:invalid_json) { 'total nonsense' }

    before(:each) do
      service.json_input = invalid_json
      service.execute
    end

    it { expect(service.errors).to be_present }
    it { expect(service.errors).to be_truthy }
    it { expect(service.errors).to include 'Unable to parse JSON' }
  end

  describe 'with valid short-form JSON data' do
    let(:valid_json) { '{"name":"yourhost","a":"1.2.3.4","aaaa":"2001:db8::1"}' }
    let(:user) { FactoryBot.create(:user) }

    before(:each) do
      service.json_input = valid_json
      service.user = user
      service.execute
    end

    it { expect(service.errors).to be_empty }
    it { expect(ResourceRecord.all.count).to eq 2 }
    it { expect(ARecord.first.data).to eq '1.2.3.4' }
    it { expect(ARecord.first.user).to eq user }
    it { expect(AAAARecord.first.data).to eq '2001:db8::1' }
    it { expect(AAAARecord.first.user).to eq user }
  end
end
