require 'spec_helper'

RSpec.describe Zone, :type => :model do
  let!(:now) { Time.now }
  let!(:zone) { FactoryBot.create(:zone) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  context 'when updating the serial number' do
    it 'should increment by one when exported_at is today' do
      zone.update_serial
      expect(zone.serial).to eq "#{now.strftime("%Y%m%d")}01".to_i
    end

    it 'should reset to zero when exported_at is on a previous day' do
      zone.serial = "#{Date.today.prev_day.strftime("%Y%m%d")}23".to_i
      zone.update_serial
      expect(zone.serial).to eq "#{now.strftime("%Y%m%d")}00".to_i
    end
  end

  context '#resource_record_changed?' do
    it { expect(zone.resource_records_changed?).to be_truthy }

    it 'should return false when no resource record has been changed since last export' do
      zone.exported_at = now
      zone.resource_records << ARecord.new(:updated_at => Date.today.prev_day)
      expect(zone.resource_records_changed?).to be_falsey
    end

    it 'should return true when a resource record has been changed since last export' do
      zone.exported_at = now
      zone.resource_records << ARecord.new(:updated_at => Time.now)
      expect(zone.resource_records_changed?).to be_truthy
    end
  end
end