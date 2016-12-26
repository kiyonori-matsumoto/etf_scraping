class UserSettingService

  class << self

    def portfolio(user)
      portfolio = Hash.new(0)
      Issue::TYPES.each do |type|
        portfolio[I18n.t "attributes.#{type}"] = user.user_setting.send(type)
      end
      portfolio
    end

    def passed_date_first_year(user)
      setting = user.user_setting
      if setting.start_date.year == Date.today.year
        1 - setting.start_date.yday / Date.today.end_of_year.yday.to_f
      else
        1
      end
    end
  end
end
