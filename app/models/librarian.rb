class Librarian < ApplicationRecord
	belongs_to :user
	validates :library_id, presence: true
	validates :user_id, presence: true
end
