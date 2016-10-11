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
      portfolio_current = portfolio(user)
      portfolio_future  = UserSettingService.portfolio(user)
      portfolio = portfolio_current.map { |e| e[1] -= (portfolio_future[e[0]] * total_assets) / 100; e }
    end
  end
end
