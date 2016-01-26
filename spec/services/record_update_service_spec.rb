require_relative '../../services/record_update_service'

RSpec.describe 'RecordUpdateService' do
  let (:service) { RecordUpdateService.new }

  it { expect(service).not_to be_nil }
end