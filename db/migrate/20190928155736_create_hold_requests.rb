class CreateHoldRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :hold_requests do |t|
      t.integer :user_id
      t.string :isbn

      t.timestamps
    end
  end
end


