class ChangeLibraryCol < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :library
    remove_column :librarians, :library
    add_column :books, :library_id, :integer
    add_column :librarians, :library_id, :integer


  end
end
