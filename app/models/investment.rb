class Investment < ActiveRecord::Base
  has_many :investment_dailies, foreign_key: :investment_code

  self.primary_key = :code

  def latest_daily
    investment_dailies.order(created_at: :desc).first
  end

end
