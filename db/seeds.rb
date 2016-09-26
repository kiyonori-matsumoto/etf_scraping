# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

data = [
  ["iシェアーズ TOPIX ETF", "1475", "https://www.blackrock.com/jp/individual/ja/products/279438/"]
]

data.each do |d|
  Issue.create(name: d[0], code: d[1], url: d[2])
end
