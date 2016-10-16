google.charts.load('current', {'packages': ['corechart']})

drawChart = ->
  data = new google.visualization.DataTable()
  data.addColumn('date', 'date')
  data.addColumn('number', 'total')
  data.addRows(convert(<%= raw @chart.to_json %>))

  options = {
    # width: '100%', height: 300, vAxis: {format: 'currency'},
    legend: {position: 'none'},
    theme: 'maximized'
  }
  chart = new google.visualization.ColumnChart(document.getElementById('chart_div'))
  chart.draw(data, options)

convert = (l) ->
  l.map (e) ->
    [new Date(e[0]), parseInt(e[1])]

google.charts.setOnLoadCallback(drawChart)
