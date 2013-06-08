window.onload = function() {
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

var chart = null;

function renderChart(data) {
  var chart_type = $('#chart_type').val();

  var canvas = $("#linechart");
  var ctx = canvas.get(0).getContext("2d");

  if (chart == null) {
    chart = new Chart(ctx);
  }

  if (chart_type === 'bar') {
    chart.Bar(data, null);
  } else {
    chart.Line(data, null);
  }
}

function loadApp() {
  var app_id = $('#app_id').val();
  
  loadAppData(app_id);
}

function loadAppData(app_id) {
  $.get('/ratings/' + app_id, function(read_data) {
    var status = read_data.status;
    var results = read_data.results;
    var info = results.info;

    $('#app_name').text(info.app_name);
    $('#app_version').text('Version: ' + info.app_version);

    var records = results.records;
    var plot_data_total = Array();
    var plot_data_verion = Array();
    var labels = Array();

    if (records.length > 1) {
      for (var i in records) {
        var r = records[i];
        
        // plot_data_total.push(r.ratings_total_avg);
        plot_data_verion.push(r.ratings_version_avg);
        labels.push(r.chart_label);
      }

      var data = {
        labels : labels,
        datasets : [
          // {
          //     fillColor : "rgba(220,220,220,0.5)",
          //     strokeColor : "rgba(220,220,220,1)",
          //     pointColor : "rgba(220,220,220,1)",
          //     pointStrokeColor : "#fff",
          //     data : plot_data_total
          // },
          {
            fillColor : "rgba(151,187,205,0.5)",
            strokeColor : "rgba(151,187,205,1)",
            pointColor : "rgba(151,187,205,1)",
            pointStrokeColor : "#fff",
            data : plot_data_verion
          }
        ]
      };

      renderChart(data);
    } else {
      alert('Sorry, there is not enough ratings to show yet. Need at least two days of data to show.');
    }
  });
}