require 'spec_helper'

RSpec.describe 'AAAARecord' do
  let(:aaaa_record) { FactoryBot.build(:a_a_a_a_record, :data => '2001:db8:1::1234') }

  it { expect(aaaa_record.type).to eq 'AAAA' }
  it { expect(aaaa_record.data).to eq '2001:db8:1::1234' }
  it { expect(aaaa_record.ttl).to eq 300 }
  it { expect(aaaa_record.ptr_data).to eq '4.3.2.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa' }
end