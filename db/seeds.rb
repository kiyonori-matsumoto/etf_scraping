# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def blackrock_url(id)
  "https://www.blackrock.com/jp/individual/ja/products/#{id}/"
end

def daiwa_url(id)
  "http://etf.daiwa-am.co.jp/funds/detail/detail_top.php?code=#{id}"
end

data = [
  { name: 'ishares topix', code: '1475', url: blackrock_url('279438'), company: 'blackrock', base_unit: 1, trade_unit: 1 },
  { name: 'nikko topix', code: '1308', url: '', company: 'nikko', base_unit: 1, trade_unit: 100 },
  { name: 'nikko jpx400', code: '1592', url: '', company: 'nikko', base_unit: 10, trade_unit: 10 },
  { name: 'daiwa topix', code: '1305', url: daiwa_url('5841'), company: 'daiawa', base_unit: 10, trade_unit: 10},
  { name: 'daiwa jpx400', code: '1599', url: daiwa_url('3500'), company: 'daiwa', base_unit: 1, trade_unit: 1}
]

data.each do |d|
  i = Issue.new d
  p i
  i.save
end

u = User.create(email: 'test@example.com', password: 'foobar', password_confirmation: 'foobar')
u.user_setting.update_attributes yearly_deposit: 1000000, start_date: 4.month.ago
# u.user_setting.yearly_deposit = 1000000
# u.user_setting.start_date = 4.month.ago
# u.user_setting.save

10.times do |n|
  u.user_issue.create(issue_code: '1475', price: 1000 + n * 10, num: n + 1, bought_day: Date.today.days_ago(n))
end
