class Issue < ActiveRecord::Base
  has_many :dailies
  validates :company, presence: true, inclusion: { in: %w(nikko blackrock daiwa) }
end
