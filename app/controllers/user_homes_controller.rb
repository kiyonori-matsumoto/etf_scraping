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
    data = current_user.user_issues.select([:bought_day, :price])
          .inject(Hash.new(0)) { |a, e| a[e.bought_day.to_date] = e.price.to_i; a }
    n = 0
    data2 = (current_user.user_setting.start_date.to_date..Date.today)
    .inject({}) { |a, e| a[e] = (n += data[e]); a }
    p data
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '今年度投資計画・実績')
      f.xAxis(type: :datetime)
      f.yAxis([{}, {opposite: true}])
      f.series(name: "投資額", yAxis: 0, data: data.map { |e| [e[0].strftime('%Q').to_i, e[1]] })
      f.series(name: "投資累計", yAxis: 1, data: data2.map { |e| [e[0].strftime('%Q').to_i, e[1]] }, type: 'line')
      f.chart({defaultSeriesType: "column"})
      f.responsive(
        rules: [{
          condition: { maxWidth: 500 },
          chartOptions: {
            legend: { enabled: false, y: 0, x: 0, align: 'center' },
          }
        }]
      )
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
  end

  private

  def jdate(date)
    "Date.UTC(#{date.year},#{date.month-1},#{date.day})"
  end
end
