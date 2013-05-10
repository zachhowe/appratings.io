function loadAppsList()
{
    $.get('/list', function(resp) {
        var status = resp.status;
        if (status !== 'ok') {
            alert(status);
        } else {
            var results = resp.results;
            for (var i in results) {
                var app = results[i];
                $("#app_id").append('<option value="' + app.app_id + '">' + app.app_name + '</option>');
            } 
        }
    });
}

function renderLineChart(data)
{
    var ctx = $("#linechart").get(0).getContext("2d");
    var myNewChart = new Chart(ctx);
    myNewChart.Line(data, null);
}

function loadApp()
{
    var app_id = $('#app_id').val();
    loadLineGraph(app_id);
}

function loadLineGraph(app_id)
{
    $.get('/ratings/' + app_id, function(read_data) {
        var status = read_data.status;
        var results = read_data.results;
        var info = results.info;
        $('#app_name').text(info.app_name);
        $('#app_version').text('Version: ' + info.app_version);

        var records = results.records;
        var plot_data = Array();
        var labels = Array();

        if (records.length > 1) {
            for (var i in records) {
                var r = records[i];

                plot_data.push(r.average);
                labels.push(r.date);
            }

            var data = {
                labels : labels,
                datasets : [
                {
                    fillColor : "rgba(220,220,220,0.5)",
                    strokeColor : "rgba(220,220,220,1)",
                    pointColor : "rgba(220,220,220,1)",
                    pointStrokeColor : "#fff",
                    data : plot_data
                }
            ]};

            renderLineChart(data);
        } else {
            alert('Sorry, there is not enough ratings to show yet. Need at least two days of data to show.');
        }
    });
}