function loadAppsList()
{
    $.get('/list', function(resp) {
        var status = resp.status;
        if (status !== 'ok') {
            alert('Error: ' + status);
        } else {
            var results = resp.results;
            for (var i in results) {
                var app = results[i];
                $("#apps_list").append('<tr class="app"><td>' + app.app_id + '</td><td>' + app.app_name + '</td></tr>');
            }
        }
    });
}

function addApp()
{
    var app_id = $('#app_id').val();
    
    $.get('/admin/add/' + app_id, function(data) {
        var status = data.status;
        if (status !== 'ok') {
            alert('Error: ' + status);
        } else {
        	alert('Succesfully added App ID to list. It could take up to an hour for data to appear.');
            $('#app_id').val('');
        }
    });
}
