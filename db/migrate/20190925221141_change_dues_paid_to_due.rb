class ChangeDuesPaidToDue < ActiveRecord::Migration[5.2]
  def change
    remove_column :students, :dues_paid
    add_column :students, :dues, :float
  end
end
