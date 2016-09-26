require 'open-uri'
require 'nokogiri'

namespace :scrape do
  task :update do
    Issue.all.each do |iss|
      url = iss.url
      html = open(url) do |f|
        f.read
      end
      doc = Nokogiri::HTML.parse(html)
      daily = iss.dailies.new
      daily.base_price = doc.css('span.nav-value')[0].children.text.strip.gsub(/[^\d\.]/, '').to_f
      daily.issue_price = doc.css('span.nav-value')[1].children.text.strip.gsub(/[^\d\.]/, '').to_f
      daily.total_assets = doc.css('tr.totalNetAssets .data').text.strip.gsub(/[^\d\.]/, '').to_f
      daily.total_issued = doc.css('tr.sharesOutstanding .data').text.strip.gsub(/[^\d\.]/, '').to_f
      daily.save
    end
  end
end
