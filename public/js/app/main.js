define(function(require, exports) {
  var showError, renderChart, loadAppIcon, loadAppData, loadAppDataByVersions, generateChartData, clearError;

  showError = function(error_msg) {
    $('#error').text(error_msg);
  };

  clearError = function() {
    showError('');
  };

  renderChart = function(firstDate, data_in) {
    var chart = new Highcharts.Chart({
      chart: {
        renderTo: 'container',
        zoomType: 'x'
      },
      title: {
        text: 'All Versions App Ratings'
      },
      subtitle: {
        text: document.ontouchstart === undefined ?
          'Click and drag in the plot area to zoom in' :
          'Pinch the chart to zoom in'
      },
      xAxis: {
        type: 'datetime',
        minRange: 14 * 24 * 3600 * 1000
      },
      yAxis: {
        title: {
          text: 'Average Rating'
        }
      },
      legend: {
        enabled: false
      },
      plotOptions: {
        area: {
          fillColor: {
            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
            stops: [
              [0, Highcharts.getOptions().colors[0]],
              [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
            ]
          },
          marker: {
            radius: 2
          },
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 1
            }
          },
          threshold: null
        }
      },
      series: [{
        type: 'area',
        name: 'Average Ratings',
        pointInterval: 24 * 3600 * 1000,
        pointStart: Date.parse(firstDate),
        data: data_in
      }]
    });
  };

  loadAppIcon = function(app_id) {
    $.get('/api/info/' + app_id, function(data) {
      var status = data.status;
      var results = data.results;

      var app_icon = $('#app_icon');
      app_icon.show();
      app_icon.attr('src', results.artworkUrl60);
    });
  };

  loadAppData = function(app_id, callback) {
    if (typeof callback == "undefined") {
      callback = renderChart;
    }

    $.get(sprintf('/api/raw/%s', app_id), function(read_data) {
      generateChart(read_data);
    });
  };

  generateChart = function(read_data) {
    var status = read_data.status;
    var results = read_data.results;
    var info = results.info;
    var first = results.first;

    $('#app_name').text(info.app_name);
    $('#app_version').text('Current Version: ' + info.app_version);

    var records = results.records;
    renderChart(first, records);
  }

  var chart = null;

  exports.getAppList = function() {
    $.get('/api/list', function(resp) {
      var status = resp.status;
      if (status !== 'ok') {
        console.log(status);
      } else {
        var results = resp.results;
        for (var i in results) {
          var app = results[i];

          $("#app_id").append(sprintf('<option value="%s">%s</option>', app.app_id, app.app_name));
        }
      }
    });
  };

  exports.loadApp = function(app_id) {
    if (typeof app_id == "undefined") {
      app_id = $('#app_id').val();
    }

    loadAppIcon(app_id);
    loadAppData(app_id);
  };
});
