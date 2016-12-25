module ApplicationHelper
  def unit
    {units: {hundred: "百",:thousand => "千", :million => "百万", :billion => "十億", :trillion => "兆", :quadrillion => "千兆"}, precision: 5}
  end
end
