class User < ApplicationRecord
	has_many :students, dependent: :destroy
	has_many :librarians, dependent: :destroy
	validates :email, presence: true,uniqueness: true
	validates :name, presence: true
	validates :password, presence: true
	validates :role, presence: true
end
