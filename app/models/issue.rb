class Issue < ActiveRecord::Base
  has_many :dailies
  validates :company, presence: true, inclusion: { in: %w(nikko blackrock daiwa) }

  # self.primary_key = :code
end
