class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :name
      t.integer :serial
      t.text :template
      t.datetime :exported_at
      t.timestamps
    end
  end
end
