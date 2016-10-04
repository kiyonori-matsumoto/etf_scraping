class Issue < ActiveRecord::Base
  has_many :dailies, foreign_key: :issue_code
  validates :company, presence: true, inclusion: { in: %w(nikko blackrock daiwa) }

  self.primary_key = :code
end
