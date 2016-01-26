class RecordUpdateService
  attr_writer :user, :json_input
  attr_reader :errors

  def initialize
    @errors = []
  end

  def execute
    process_json
    return if errors.any?
    save_resource_records
  end

  private

  def process_json
    json_processor = JsonProcessorService.new
    json_processor.input = @json_input
    json_processor.execute
    errors << 'Unable to parse JSON' if json_processor.errors
    @resource_records = json_processor.resource_records    
  end

  def save_resource_records
    @resource_records.each do |rr|
      rr.user = @user
      rr.save!
    end
  end
end