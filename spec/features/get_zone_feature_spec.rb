require 'spec_helper'
require 'rack/test'
require 'timecop'

RSpec.describe 'GET a DNS zone', :type => :feature do
  include Rack::Test::Methods

  def app
    DynamicDns
  end

  describe 'get a zone that does not exist' do
    before(:each) do
      get '/zone/notazone'
    end

    it { expect(last_response.status).to eq 404 }
    it { expect(last_response.content_type).to start_with 'text/plain' }
    it { expect(last_response.body).to eq 'Not found' }
  end

  let(:test_template) { open('spec/support/test_template.erb').read }
  let(:test_zone) { FactoryBot.create(:zone_with_records, :template => test_template) }
  let(:a_record) { test_zone.resource_records.where(:sti_type => 'ARecord').first }
  let(:aaaa_record) { test_zone.resource_records.where(:sti_type => 'AAAARecord').first }
  let(:results) { last_response.body }

  describe 'get a zone that does exist' do
    before(:each) do
      get "/zone/#{test_zone.name}"
    end

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.content_type).to start_with 'text/plain' }

    it { expect(results).to include '; This zone file is dynamically generated, DO NOT HAND EDIT!' }
    it { expect(results).to include "; Generated #{Date.today.to_s}"}
    it { expect(results).to include (test_zone.serial + 1).to_s }
    it { expect(results).to match(/^#{a_record.name}\s+300\s+A\s+#{a_record.data}$/) }
    it { expect(results).to match(/^#{aaaa_record.name}\s+300\s+AAAA\s+#{aaaa_record.data}$/) }

    it 'should set the exported_at date on the Zone' do
      test_zone.reload
      expect(test_zone.exported_at.to_date).to be >= Date.today
    end

    it 'should update the Zone serial' do
      old_serial = test_zone.serial
      get "/zone/#{test_zone.name}"
      test_zone.reload

      expect(test_zone.serial).to be > old_serial
    end
  end

  describe 'get a zone that does exist with ETag' do
    before(:each) do
      # The following ensures we don't have a race condition between updated_at on the
      # ResourceRecords and exported_at on the Zone.
      Timecop.freeze(1.day.ago) do
        test_zone
      end

      get "/zone/#{test_zone.name}"
      test_zone.reload      
      header 'If-None-Match', "\"#{(test_zone.serial).to_s}\""
      get "/zone/#{test_zone.name}"
    end

    it { expect(last_response.status).to eq 304 }
    it { expect(last_response.body).to be_empty }
  end
end
