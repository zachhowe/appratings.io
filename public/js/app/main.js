define(function(require, exports) {
  var showError, renderChart, loadAppIcon, loadAppData, loadAppDataByVersions, generateChartData, clearError;

  showError = function(error_msg) {
    $('#error').text(error_msg);
  };

  clearError = function() {
    showError('');
  };

  renderChart = function(data) {
    var chart_type = $('#chart_type').val();

    var canvas = $("#chart");
    var ctx = canvas.get(0).getContext("2d");

    if (chart == null) {
      chart = new Chart(ctx);
    }

    if (chart_type === 'bar') {
      chart.Bar(data, null);
    } else {
      chart.Line(data, null);
    }
  };

  loadAppIcon = function(app_id) {
    $.get('/info/' + app_id, function(data) {
      var status = data.status;
      var results = data.results;

      var app_icon = $('#app_icon');
      app_icon.show();
      app_icon.attr('src', results.artworkUrl60);
    });
  };

  loadAppDataByVersions = function(app_id, callback) {
    if (typeof callback == "undefined") {
      callback = renderChart;
    }

    $.get(sprintf('/versions/%s', app_id), function(versions_read_data) {
      var versions = versions_read_data.results;
      var versions_to_show = Math.min(15, versions.length);
      var version_list = versions.slice(versions.length - versions_to_show).join();

      $.get(sprintf('/ratings/%s/by-versions/%s', app_id, version_list), function(read_data) {
        var chartData = generateChartData(read_data);
        if (chartData !== null) callback(chartData);
      });
    });
  };

  loadAppData = function(app_id, callback) {
    if (typeof callback == "undefined") {
      callback = renderChart;
    }

    $.get(sprintf('/ratings/%s', app_id), function(read_data) {
      var chartData = generateChartData(read_data);
      if (chartData !== null) callback(chartData);
    });
  };

  generateChartData = function(read_data) {
    var status = read_data.status;
    var results = read_data.results;
    var info = results.info;

    $('#app_name').text(info.app_name);
    $('#app_version').text('Current Version: ' + info.app_version);

    var records = results.records;
    var plot_data_version = [];
    var labels = [];

    if (records.length > 1) {
      for (var i in records) {
        var r = records[i];

        plot_data_version.push(r.ratings_version_avg);
        labels.push(r.chart_label);
      }

      var data = {
        labels : labels,
        datasets : [
          {
            fillColor : "rgba(151,187,205,0.5)",
            strokeColor : "rgba(151,187,205,1)",
            pointColor : "rgba(151,187,205,1)",
            pointStrokeColor : "#fff",
            data : plot_data_version
          }
        ]
      };

      clearError();
      
      return data;
    } else {
      showError('Sorry, there is not enough data to build a graph yet.');

      return null;
    }
  };

  var chart = null;

  exports.getAppList = function() {
    $.get('/list', function(resp) {
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
    loadAppData(app_id, renderChart);
  };

  exports.loadAppVersions = function(app_id) {
    if (typeof app_id == "undefined") {
      app_id = $('#app_id').val();
    }

    loadAppIcon(app_id);
    loadAppDataByVersions(app_id, renderChart);
  };
});
