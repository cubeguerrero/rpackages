class Authorship < ApplicationRecord
  belongs_to :person
  belongs_to :package
end
