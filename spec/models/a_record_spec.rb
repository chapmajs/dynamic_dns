require 'spec_helper'

RSpec.describe 'ARecord' do
  let(:a_record) { ARecord.new(:name => 'testhost', :ttl => 300, :data => '1.2.3.4') }

  it { expect(a_record.type).to eq 'A' }
  it { expect(a_record.ptr_data).to eq '4.3.2.1.in-addr.arpa' }
end