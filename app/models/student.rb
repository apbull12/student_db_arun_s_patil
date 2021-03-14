class Student < ApplicationRecord
  belongs_to :institution

  scope :accepted, -> { where(status: 'accepted') }
  scope :get_pending, -> { where(status: 'pending') }

  validates :full_name, presence: true
  validates :mobile, presence: true, uniqueness: true
end
