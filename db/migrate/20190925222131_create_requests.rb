class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :user_id
      t.string :isbn
      t.integer :status

      t.timestamps
    end
  end
end
