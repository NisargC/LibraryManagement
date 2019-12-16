class BorrowedHistory < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :books, dependent: :destroy
  validates :book_id, presence: true
  validates :borrowed_on, presence: true
  validates :due_on, presence: true
  validates :user_id, presence: true
  validates :isbn, presence: true
end
