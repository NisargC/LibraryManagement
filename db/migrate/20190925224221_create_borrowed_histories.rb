class CreateBorrowedHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :borrowed_histories do |t|
      t.string :isbn
      t.string :user_ids

      t.timestamps
    end
  end
end
