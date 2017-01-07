module ApplicationHelper
  def unit
    {units: {hundred: "百",:thousand => "千", :million => "百万", :billion => "十億", :trillion => "兆", :quadrillion => "千兆"}, precision: 5}
  end

  def my_high_chart_globals
    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        # backgroundColor: {
        #   linearGradient: [0, 0, 500, 500],
        #   stops: [
        #     [0, "rgb(255, 255, 255)"],
        #     [1, "rgb(240, 240, 255)"]
        #   ]
        # },
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        # plotShadow: true,
        # plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
    high_chart_globals(@chart_globals)
  end
end
