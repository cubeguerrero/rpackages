class Package < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
