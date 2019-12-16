class Addtitle < ActiveRecord::Migration[5.2]
  def change
    add_column :borrowed_histories, :title, :string
  end
end
