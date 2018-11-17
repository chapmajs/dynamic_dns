class CreateResourceRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_records do |t|
      t.references :user
      t.references :zone
      t.string :name
      t.integer :ttl
      t.string :data
      t.string :sti_type
      t.timestamps
    end
  end
end
