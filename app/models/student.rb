class Student < ApplicationRecord
	belongs_to :user
	validates :university, presence: true
	validates :education_level, presence: true
end
