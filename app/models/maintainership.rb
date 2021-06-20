class Maintainership < ApplicationRecord
  belongs_to :package
  belongs_to :person
end
