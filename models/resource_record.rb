class ResourceRecord < ActiveRecord::Base
  self.inheritance_column = :sti_type

  belongs_to :user

  validates :name, :presence => true
  validates :data, :presence => true

  def type
    self.class.name.sub('Record', '')
  end
end