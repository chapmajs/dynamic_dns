require 'json-schema'

class JsonProcessorService
  attr_writer :input
  attr_reader :errors, :name, :resource_records

  def initialize
    @resource_records = []
  end

  def execute
    validate_json
    return if @errors
    parse_json
    build_resource_records
  end

  private

  def validate_json
    @errors = !JSON::Validator.validate('config/short_form_update.json', @input)
  end

  def parse_json
    params = JSON.parse(@input)
    @name = params.delete('name').downcase
    @resource_record_params = params.collect { |k,v| {:type => k.upcase, :data => v} }
  end

  def build_resource_records
    @resource_records = @resource_record_params.collect do |record_params|
      rr = "#{record_params[:type]}Record".constantize.find_or_initialize_by(:name => @name)

      rr.ttl = 300
      rr.data = record_params[:data]
      rr
    end
  end
end