require 'open-uri'
require 'nokogiri'

namespace :scrape do
  task nikko: [:environment] do
    base_hash = {}
    total_hash = {}
    url = 'http://www.nikkoam.com/ajax-navlist?format=json'
    json = JSON.load(open(url))
    json.each do |iss|
      code = iss['fund_cd'][1..4]
      base_hash[code] = iss['standard_price'].tr(',', '').to_f
      total_hash[code] = iss['pure_assets_total'].tr(',', '').to_f * 1_000_000
    end

    Issue.where(company: 'nikko').each do |iss|
      # 東証の情報を取得する
      daily = iss.dailies.new
      r = tosho_info(iss.code, daily)

      daily.base_price = base_hash[iss.code] / r[:unit]
      daily.total_assets = total_hash[iss.code]
      daily.save
    end
  end

  task blackrock: [:environment] do
    Issue.where(company: 'blackrock').each do |iss|
      # 東証の情報を取得する
      daily = iss.dailies.new
      tosho_info(iss.code, daily)

      url = iss.url
      html = open(url, &:read)
      doc = Nokogiri::HTML.parse(html)
      daily.base_price = doc.css('span.nav-value')[0].children.text.strip.gsub(/[^\d\.]/, '').to_f
      daily.end_price = doc.css('span.nav-value')[1].children.text.strip.gsub(/[^\d\.]/, '').to_f
      daily.total_assets = doc.css('tr.totalNetAssets .data').text.strip.gsub(/[^\d\.]/, '').to_f
      daily.total_issued = (doc.css('tr.sharesOutstanding').any? ?
                            doc.css('tr.sharesOutstanding .data') :
                            doc.css('tr.underLyingSharesOutstanding .data'))
                           .text.strip.gsub(/[^\d\.]/, '').to_f
      daily.save
    end
  end

  task update: [:blackrock, :nikko]

  def tosho_info(code, daily)
    retries = 0
    r = {}
    url = "http://quote.jpx.co.jp/jpx/template/quote.cgi?F=tmp/stock_detail&MKTN=T&QCODE=#{code}"
    begin
      doc = Nokogiri::HTML.parse(open(url))
    rescue OpenURI::HTTPError => e
      retries += 1
      raise e if retries > 10
      sleep(retries)
      retry
    end
    doc.css('td').map(&:text).each_cons(2) do |vals|
      case vals[0]
      when '現在値 (時刻)' then daily.end_price = conv(vals[1].split(/\s+/)[0])
      when '始値' then daily.start_price = conv(vals[1])
      when '高値' then daily.high_price = conv(vals[1])
      when '安値' then daily.low_price = conv(vals[1])
      when '発行済株式数' then daily.total_issued = conv(vals[1])
      when '売買単位' then r[:unit] = conv(vals[1])
      end
    end
    puts "#{code}: retry: #{retries}"
    r
  end

  private

  def conv(str)
    str.tr(',', '').to_f
  end
end
