FactoryGirl.define do
  factory :issue do
    name 'issuename'
    code '1234'
    url  'http://www.example.com'
    company 'nikko'
    base_unit 1
    trade_unit 1
  end
end
