class Request < ApplicationRecord
  has_many :user
  validates :user_id, presence: true
  validates :status, presence: true
end
