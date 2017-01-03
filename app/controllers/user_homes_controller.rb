class UserHomesController < ApplicationController
  before_action :authenticate_user!

  def show
    @my_issues = current_user.user_issues
    @user_issues = UserIssueService.user_issues_total_having(current_user)
    @my_investments = current_user.user_investments
    @user_investments = UserInvestmentService.user_investments_total_having(current_user)
    @v = {}
    [:current_profit, :total_paid, :current_price].each do |d|
      @v[d] = @user_issues.inject(0) { |a, e| a + e[1][d] } +
              @user_investments.inject(0) { |a, e| a + e[1][d] }
    end
    @v[:year_deposit] = current_user.user_setting.yearly_deposit *
                      UserSettingService.passed_date_first_year(current_user)
    @v[:current_profit_rate] = @v[:current_price] / @v[:total_paid] - 1
  end

  def dashboard
    data = current_user.user_issues.select([:bought_day, :price, :num])
          .inject(Hash.new(0)) { |a, e| a[e.bought_day.to_date] += (e.price * e.num).to_i; a }
    data = current_user.user_investments.select([:bought_day, :price, :num])
          .inject(data) { |a, e| a[e.bought_day.to_date] += e.price.to_i; a }

    n = 0
    data2 = (current_user.user_setting.start_date.to_date..Date.today)
    .inject({}) { |a, e| a[e] = (n += data[e]); a }

    n = 0
    d = current_user.user_setting.yearly_deposit.to_f / (Date.leap?(Date.today.year) ? 366 : 365)
    data3 = (current_user.user_setting.start_date.to_date..Date.today)
    .inject({}) { |a, e| a[e] = (n += d) ; a }
    .map { |e| [e[0].strftime('%Q').to_i, e[1].to_i] }

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '投資計画・実績')
      f.legend(verticalAlign: 'top')
      f.xAxis(type: :datetime, labels: {y: 16})
      f.yAxis([{title: {text: nil}, id: "1"}, {title: {text: nil}, id: "2"}])
      f.tooltip(shared: true, valueDecimals: 0)
      f.series(name: "投資累計", yAxis: 1, data: data2.map { |e| [e[0].strftime('%Q').to_i, e[1]] }, type: 'line')
      f.series(name: "投資目標", yAxis: 1, data: data3, type: 'line', dashStyle:'ShortDot')
      f.chart({defaultSeriesType: "column", zoomType: 'x'})
      f.series(name: "投資額", yAxis: 0, data: data.sort.map { |e| [e[0].strftime('%Q').to_i, e[1]] })
      f.responsive(
        rules: [{
          condition: { maxWidth: 500 },
          chartOptions: {
            legend: { enabled: false, y: 0, x: 0, align: 'center' },
            yAxis: [{title: {text: nil}, id: "1", visible: false}, {title: {text: nil}, id: "2", visible: false}]
          }
        }]
      )
    end

    data3 = UserIssueService.portfolio(current_user) + UserInvestmentService.portfolio(current_user)
    p data3

    @chart2 = LazyHighCharts::HighChart.new('graph2') do |f|
      f.chart(height: 350)
      f.title(text: 'ポートフォリオ', aligh: 'center')
      f.plotOptions(pie: {dataLabels: {
        enabled: true, distance: -50, style: { color: 'white'}
        }, startAngle: -90, endAngle: 90, center: ['50%', '50%']})
      f.series(
        type: 'pie',
        name: '現在価額',
        innerSize: '50%',
        data: data3.map { |e| [e[0], e[1].to_i] }
          .delete_if { |e| e[1] <= 0 }
      )
    end

    @chart3 = LazyHighCharts::HighChart.new('graph3') do |f|
      f.title(text: '')
    end

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
  end
end
