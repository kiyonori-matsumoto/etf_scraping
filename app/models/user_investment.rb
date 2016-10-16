class UserInvestment < ActiveRecord::Base
  belongs_to :user
  belongs_to :investment, primary_key: :code, foreign_key: :investment_code
end
