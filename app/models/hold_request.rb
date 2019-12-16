class HoldRequest < ApplicationRecord
  has_many :users
  validates :user_id, presence: true
  validates :isbn, presence: true
end
