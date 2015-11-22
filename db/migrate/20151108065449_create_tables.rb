class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string      :name
      t.integer     :max_persons, default: 0, null: false
      t.integer     :num_persons, default: 0, null: false
      t.boolean     :occupied,    default: false
      t.integer     :total_bill,  default: 0, null: false
      t.timestamps                null: false
    end
  end
end
