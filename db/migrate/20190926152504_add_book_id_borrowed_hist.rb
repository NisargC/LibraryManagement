class AddBookIdBorrowedHist < ActiveRecord::Migration[5.2]
  def change
    add_column :borrowed_histories, :book_id, :integer
  end
end
