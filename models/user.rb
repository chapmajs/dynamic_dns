class User < ActiveRecord::Base
  has_secure_password

  has_many :resource_records

  validates :username, :presence => true, :uniqueness => { :case_sensitive => true }
end