class EditBorrowedHist < ActiveRecord::Migration[5.2]
  def change
    remove_column :borrowed_histories, :user_ids
    add_column :borrowed_histories, :user_id, :integer
    add_column :borrowed_histories, :borrowed_on, :datetime
    add_column :borrowed_histories, :due_on, :datetime
    add_column :borrowed_histories, :returned_on, :datetime
  end
end
