class Package < ApplicationRecord
  has_many :versions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
