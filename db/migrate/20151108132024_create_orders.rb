class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string      :name
      t.decimal     :price,     precision: 7, scale: 2, default: 0, null: false
      t.integer     :quantity,  default: 0, null: false
      t.boolean     :served,    default: false
      t.timestamps              null: false
    end
  end
end
