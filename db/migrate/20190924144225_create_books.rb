class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.string :language
      t.datetime :published_date
      t.string :subject
      t.binary :front_cover
      t.integer :library
      t.string :edition
      t.boolean :special_collection
      t.integer :count

      t.timestamps
    end
  end
end
