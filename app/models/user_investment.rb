require 'nokogiri'
require 'open-uri'

class UserInvestment < ActiveRecord::Base
  belongs_to :user
  belongs_to :investment, primary_key: :code, foreign_key: :investment_code

  validate :check_investment_info

  private

  def check_investment_info
    if (Investment.find_by(code: investment_code))
      ;
    else
      doc = ""
      begin
        doc = Nokogiri::HTML.parse(open("http://tskl.toushin.or.jp/FdsWeb/view/FDST030000.seam?isinCd=#{investment_code}"))
      rescue
        errors.add(:investment_code, "投資信託が見つかりません")
        return false
      end
      i = Investment.new
      i.code = investment_code
      i.name = doc.css('.txt_3d75cf label')[0].text.strip
      i.save
      i = i.investment_dailies.new
      i.base_price = doc.css('.pdr10 label')[0].text.gsub(/[^\d\.]/, "").to_i
      i.save
    end
  end
end
