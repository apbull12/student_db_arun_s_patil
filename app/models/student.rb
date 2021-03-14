class Student < ApplicationRecord
  belongs_to :institution

  validates :full_name, presence: true
  validates :mobile, presence: true, uniqueness: true
end
