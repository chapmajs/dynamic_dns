require 'spec_helper'

RSpec.describe 'AddressRecord' do
  
  describe '#ptr_data' do
    it 'should be abstract and raise an error' do
      ar = AddressRecord.new
      expect { ar.ptr_data }.to raise_error('AddressRecord is abstract and does not implement ptr_data')
    end
  end
end