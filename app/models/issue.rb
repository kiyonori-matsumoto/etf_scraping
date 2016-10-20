class Issue < ActiveRecord::Base
  has_many :dailies, foreign_key: :issue_code
  has_many :user_issue, foreign_key: :issue_code
  validates :company, presence: true, inclusion: { in: %w(nikko blackrock daiwa) }
  TYPES = [:japan_issue,
           :japan_reit, :japan_bond, :developed_issue, :developed_reit,
           :developed_bond, :emerging_issue, :emerging_reit, :emerging_bond,
           :commodity, :unknown].freeze

  self.primary_key = :code

  def latest_daily
    dailies.order(created_at: :desc).first
  end
end
