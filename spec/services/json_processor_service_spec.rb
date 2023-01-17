require 'spec_helper'

RSpec.describe 'JsonProcessorService' do
  let(:service) { JsonProcessorService.new }

  describe 'with invalid JSON data' do
    let(:invalid_json) { 'total nonsense' }

    before(:each) do
      service.input = invalid_json
      service.execute
    end

    it { expect(service.errors).to be_present }
    it { expect(service.errors).to be_truthy }
    it { expect(service.resource_records).to be_an Array }
    it { expect(service.resource_records).to be_empty }
  end

  describe 'with valid short-form JSON data' do
    let(:valid_json) { '{"name":"yourhost","aaaa":"2001:db8::3"}' }
    let(:results) { service.resource_records }

    before(:each) do
      service.input = valid_json
      service.execute
    end

    it { expect(service.errors).to be_falsey }
    it { expect(results.size).to eq 1 }
    it { expect(results.first.data).to eq '2001:db8::3' }
    it { expect(results.first.ttl).to eq 300 }
  end
end
