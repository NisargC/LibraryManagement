class CreateLibrarians < ActiveRecord::Migration[5.2]
  def change
    create_table :librarians do |t|
      t.string :library
      t.integer :user_id

      t.timestamps
    end
  end
end
