class ChangeLibraryColBackAgain < ActiveRecord::Migration[5.2]
  def change
  end
  remove_column :books, :library
  remove_column :librarians, :library
  add_column :books, :library_id, :integer
  add_column :librarians, :library_id, :integer
end
