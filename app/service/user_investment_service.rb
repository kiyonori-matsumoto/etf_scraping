class UserInvestmentService

  class << self

    def portfolio(user)
      portfolio = Issue::TYPES.inject({}){|a, e| a[I18n.t "attributes.#{e}"] = 0; a}
      user.user_investments.each do |uiss|
        iss = uiss.investment
        portfolio[I18n.t "attributes.#{iss.portfolio_type}"] += (iss.latest_daily.base_price * uiss.num / 10000)
      end
      portfolio
    end

    def user_investments_total_having(user)
      h = {}
      user.user_investments.select(:investment_code).uniq.each do |ui|
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
