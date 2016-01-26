require 'resolv'

class ARecord < AddressRecord
	validates :data, :format => { :with => Resolv::IPv4::Regex }

	def ptr_data
		data.reverse + '.in-addr.arpa'
	end
end