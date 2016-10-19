class UserIssueService

  class << self

    def portfolio(user)
      portfolio = Issue::TYPES.inject({}){|a, e| a[I18n.t "attributes.#{e}"] = 0; a}
      user.user_issue.each do |uiss|
        iss = uiss.issue
        portfolio[I18n.t "attributes.#{iss.portfolio_type}"] += (iss.latest_daily.end_price * uiss.num)
      end
      portfolio
    end

    def distance_portfolio(user, total_assets)
      portfolio_current = portfolio(user) + UserInvestmentService.portfolio(user)
      portfolio_future  = UserSettingService.portfolio(user)
      portfolio = portfolio_current.map { |e| e[1] -= (portfolio_future[e[0]] * total_assets) / 100; e }
    end

    def user_issues_total_having(user)
      h = {}
      user.user_issue.select(:issue_code).uniq.each do |ui|
        i = ui.issue
        code = i.code
        myui = user.user_issue.where(issue_code: code)

        h[code] ||= Hash.new(0)
        h[code][:name] = i.name
        h[code][:last_bought_day] = myui.maximum(:bought_day)
        h[code][:num] = myui.sum(:num)
        h[code][:total_paid] = myui.inject(0){ |a, e| a += e.price * e.num; a }
        h[code][:average_price] = h[code][:total_paid] / h[code][:num]
        h[code][:current_price] = i.latest_daily.end_price * h[code][:num]
        h[code][:current_profit] = h[code][:current_price] - h[code][:total_paid]
      end
      h
    end
  end
end
