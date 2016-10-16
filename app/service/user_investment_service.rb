class UserInvestmentService

  class << self

    def user_investments_total_having(user)
      h = {}
      user.user_investments.group(:investment_code).preload(:investment).select([:id, :investment_code]).each do |ui|
        i = ui.investment
        code = i.code
        myui = user.user_investments.where(investment_code: code)

        h[code] ||= Hash.new(0)
        h[code][:name] = i.name
        h[code][:last_bought_day] = myui.maximum(:bought_day)
        h[code][:num] = myui.sum(:num)
        h[code][:total_paid] = myui.sum(:price)
        h[code][:average_price] = h[code][:total_paid] / h[code][:num] * 10000
        h[code][:current_price] = i.latest_daily.base_price * h[code][:num] / 10000
        h[code][:current_profit] = h[code][:current_price] - h[code][:total_paid]
      end
      h
    end
  end
end
