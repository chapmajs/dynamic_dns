require 'spec_helper'

RSpec.describe 'ARecord' do
  let(:a_record) { FactoryBot.build(:a_record, :data => '4.3.2.1') }

  it { expect(a_record.type).to eq 'A' }
  it { expect(a_record.data).to eq '4.3.2.1' }
  it { expect(a_record.ttl).to eq 300 }
  it { expect(a_record.ptr_data).to eq '1.2.3.4.in-addr.arpa' }
end