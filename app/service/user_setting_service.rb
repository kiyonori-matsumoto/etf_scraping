class UserSettingService

  class << self

    def portfolio(user)
      portfolio = Hash.new(0)
      Issue::TYPES.each do |type|
        portfolio[I18n.t "attributes.#{type}"] = user.user_setting.send(type)
      end
      portfolio
    end
  end
end
