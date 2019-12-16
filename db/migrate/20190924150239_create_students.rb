class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.integer :user_id
      t.string :education_level
      t.string :university
      t.integer :max_books
      t.integer :borrow_count
      t.float :dues_paid

      t.timestamps
    end
  end
end
