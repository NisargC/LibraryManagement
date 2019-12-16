class DatetimeToDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :borrowed_histories, :borrowed_on
    remove_column :borrowed_histories, :due_on
    remove_column :borrowed_histories, :returned_on
    add_column :borrowed_histories, :borrowed_on, :Date
    add_column :borrowed_histories, :due_on, :Date
    add_column :borrowed_histories, :returned_on, :Date
  end
end
