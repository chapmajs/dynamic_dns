require 'resolv'

class AAAARecord < AddressRecord
  validates :data, :format => { :with => Resolv::IPv6::Regex }

  def data=(value)
    super(value.try(:downcase))
  end

  def ptr_data
    Resolv::IPv6.create(data).to_name.to_s
  end
end