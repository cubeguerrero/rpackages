class Package < ApplicationRecord
  has_many :versions, dependent: :destroy
  has_many :authorships
  has_many :authors, through: :authorships, source: :person

  has_many :maintainerships
  has_many :maintainers, through: :maintainerships, source: :person

  validates :name, presence: true, uniqueness: true
end
