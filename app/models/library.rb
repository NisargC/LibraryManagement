class Library < ApplicationRecord
	has_many :books, dependent: :destroy
	has_many :librarians, dependent: :destroy
	validates :name, presence: true, uniqueness: true
	validates :university, presence: true
	validates :location, presence: true
	validates :max_days, presence: true
	validates :overdue_fines, presence: true
end
