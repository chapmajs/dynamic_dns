class AddressRecord < ResourceRecord
  def ptr_data
    raise "AddressRecord is abstract and does not implement ptr_data"
  end
end