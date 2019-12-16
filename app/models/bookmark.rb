class Bookmark < ApplicationRecord
  has_many :user
  validates :user_id, presence: true
  validates :isbn, presence: true
end
