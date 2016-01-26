class Zone < ActiveRecord::Base
  has_many :resource_records

  validates :name, :presence => true, :uniqueness => true
  # validates :template, :presence => true

  def update_serial
    if Time.now.to_date == serial_date
      self.serial +=  1
    else
      self.serial = "#{Time.now.strftime("%Y%m%d").to_i}00".to_i
    end
  end

  def resource_records_changed?
    exported_at.blank? || resource_records.any? { |rr| rr.updated_at >= exported_at }
  end

  private

  def serial_date
    Date.strptime(serial.to_s, '%Y%m%d')
  end
end