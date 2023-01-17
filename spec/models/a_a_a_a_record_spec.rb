require 'spec_helper'

RSpec.describe 'AAAARecord' do
  let(:aaaa_record) { AAAARecord.new(:name => 'v6testhost', :ttl => 300, :data => '2001:DB8:1::1') }

  it { expect(aaaa_record.type).to eq 'AAAA' }
  it { expect(aaaa_record.data).to eq '2001:db8:1::1' }
  it { expect(aaaa_record.ptr_data).to eq '1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa' }
end