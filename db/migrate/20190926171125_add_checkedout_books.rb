class AddCheckedoutBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :checked_out, :boolean, default: 0
  end
end
