class ChangeLibraryColBack < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :library_id
    remove_column :librarians, :library_id
    add_column :books, :library, :integer
    add_column :librarians, :library, :integer
  end
end
