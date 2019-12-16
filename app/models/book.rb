class Book < ApplicationRecord
  belongs_to :library
  validates :isbn, numericality: { only_integer: true }, length: { is: 13, message: 'Number must be 13 digit long.' }, uniqueness: true
  validates :title, presence: true
  validates :library, presence: true
  validates :published_date, presence: true, if: :not_future?

  def not_future?
    if published_date > Date.today
      errors.add(:published_date, 'cannot have a future date')
      false
    else
      true
    end
  end
end
