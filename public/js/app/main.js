var chart = null;

function getAppList() {
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
}

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

function loadApp(app_id) {
  if (typeof app_id == "undefined") {
    app_id = $('#app_id').val();
  }

  loadAppIcon(app_id);
  loadAppData(app_id, renderChart);
}

function loadAppIcon(app_id) {
  $.get('/info/' + app_id, function(data) {
    var status = data.status;
    var results = data.results;
    
    $("#app_icon").show();
    $("#app_icon").attr("src", results.artworkUrl60);
  });
}

function loadAppData(app_id, callback) {
  if (typeof callback == "undefined") {
    callback = renderChart;
  }
  
  $.get('/ratings/' + app_id, function(read_data) {
    var status = read_data.status;
    var results = read_data.results;
    var info = results.info;

    $('#app_name').text(info.app_name);
    $('#app_version').text('Current Version: ' + info.app_version);

    var records = results.records;
    var plot_data_verion = Array();
    var labels = Array();

    if (records.length > 1) {
      for (var i in records) {
        var r = records[i];
        
        plot_data_verion.push(r.ratings_version_avg);
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
            data : plot_data_verion
          }
        ]
      };
      
      callback(data);
    } else {
      alert('Sorry, there is not enough ratings to show yet. Need at least two days of data to show.');
    }
  });
}
