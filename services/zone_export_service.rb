class ZoneExportService
  attr_writer :zone

  def initialize
    @header_comments = []
  end

  def execute
    load_template
    calculate_column_widths
    prepare_resource_record_entries
    prepare_header_comments
    update_zone_serial
    update_zone_export_timestamp
    save_zone
    render_template
  end

  private

  def load_template
    @template = open('config/bv.theglitchworks.net.erb').read
  end

  def calculate_column_widths
    @name_column_width = ((@zone.resource_records.collect { |rr| rr.name.size }.max.to_f / 8).ceil + 1) * 8
  end

  def prepare_resource_record_entries
    @resource_record_entries = @zone.resource_records.collect do |rr|
      "#{rr.name.ljust(@name_column_width)}#{rr.ttl.to_s.ljust(8)}#{rr.type.ljust(8)}#{rr.data}"
    end
  end

  def prepare_header_comments
    @header_comments << "; This zone file is dynamically generated, DO NOT HAND EDIT!"
    @header_comments << "; Generated #{Time.now.to_s}"
  end

  def update_zone_serial
    @zone.update_serial if @zone.resource_records_changed?
  end

  def update_zone_export_timestamp
    @zone.exported_at = Time.now
  end

  def save_zone
    @zone.save!
  end

  def render_template
    ERB.new(@template).result(binding)
  end
end