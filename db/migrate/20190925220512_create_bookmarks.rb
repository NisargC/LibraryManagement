class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.string :user_id
      t.string :isbn

      t.timestamps
    end
  end
end
