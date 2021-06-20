class Version < ApplicationRecord
  belongs_to :package

  default_scope { order(published_at: :desc) }
end
