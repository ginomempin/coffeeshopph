class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :server_id
      t.integer :table_id

      t.timestamps null: false
    end
    add_index :customers, :server_id
    add_index :customers, :table_id
    add_index :customers, [:server_id, :table_id], unique: true
  end
end
