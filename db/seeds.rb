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

data = [
  { name: 'ishares topix', code: '1475', url: blackrock_url('279438'), company: 'blackrock', base_unit: 1, trade_unit: 1 },
  { name: 'nikko topix', code: '1308', url: '', company: 'nikko', base_unit: 1, trade_unit: 100 },
  { name: 'nikko jpx400', code: '1592', url: '', company: 'nikko', base_unit: 10, trade_unit: 10 }
]

data.each do |d|
  i = Issue.new d
  p i
  i.save
end
