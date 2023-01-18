require 'spec_helper'

RSpec.describe 'ZoneExportService' do
  let(:service) { ZoneExportService.new }

  describe 'generate a zone for given ResourceRecords' do
    let(:test_template) { open('spec/support/test_template.erb').read }
    let(:test_zone) { FactoryBot.create(:zone_with_records, :template => test_template) }
    let(:a_record) { test_zone.resource_records.where(:sti_type => 'ARecord').first }
    let(:aaaa_record) { test_zone.resource_records.where(:sti_type => 'AAAARecord').first }
    let(:results) { service.execute }

    before(:each) do
      service.zone = test_zone
    end

    it { expect(test_zone.exported_at).to be_blank }
    it { expect(results).not_to be_empty }
    it { expect(results).to include '; This zone file is dynamically generated, DO NOT HAND EDIT!' }
    it { expect(results).to include "; Generated #{Date.today.to_s}"}
    it { expect(results).to include test_zone.serial.to_s }
    it { expect(results).to match(/^#{a_record.name}\s+300\s+A\s+#{a_record.data}$/) }
    it { expect(results).to match(/^#{aaaa_record.name}\s+300\s+AAAA\s+#{aaaa_record.data}$/) }

    it 'should set the exported_at date on the Zone' do
      service.execute
      test_zone.reload
      expect(test_zone.exported_at.to_date).to eq Date.today
    end

    it 'should update the Zone serial' do
      old_serial = test_zone.serial
      service.execute
      service.execute
      test_zone.reload
      expect(test_zone.serial).to be > old_serial
    end
  end
end
