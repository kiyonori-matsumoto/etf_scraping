require 'open-uri'
require 'nokogiri'

class InvestmentsController < ApplicationController

  FetchResult = Struct.new(:name, :price)

  def fetch
    r = FetchResult.new
    if i = Investment.find_by(code: params[:id])
      r.name = i.name
      r.price = i.latest_daily.base_price
    else
      begin
        doc = Nokogiri::HTML.parse(open("http://tskl.toushin.or.jp/FdsWeb/view/FDST030000.seam?isinCd=#{params[:id]}"))
        r.name = doc.css('.txt_3d75cf label')[0].text.strip
        r.price = doc.css('.pdr10 label')[0].text.gsub(/[^\d\.]/, "").to_i
      rescue
        render json: r
        return
      end
    end
    render json: r
  end
end
