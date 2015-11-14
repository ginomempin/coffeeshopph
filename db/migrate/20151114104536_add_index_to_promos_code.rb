class AddIndexToPromosCode < ActiveRecord::Migration
  def change
    add_index :promos, :code, unique: true
  end
end
