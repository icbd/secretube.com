class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # soft delete
  acts_as_paranoid
end
