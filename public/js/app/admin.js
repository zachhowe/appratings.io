define(function(require, exports) {
  exports.addApp = function(app_id) {
    if (typeof app_id == "undefined") {
      app_id = $('#app_id').val();
    }

    $.get('/admin/add/' + app_id, function(data) {
      var status = data.status;
      if (status !== 'ok') {
        alert('Error: ' + status);
        console.log('Error: ' + status);
      } else {
        alert('Succesfully added App ID to list. It could take up to an hour for data to appear.');
        $('#app_id').val('');
      }
    });
  };

  exports.getAppList = function() {
    $.get('/list', function(resp) {
      var status = resp.status;
      if (status !== 'ok') {
        console.log('Error: ' + status);
      } else {
        var results = resp.results;
        for (var i in results) {
          var app = results[i];
          $("#apps_list").append(sprintf('<tr class="app"><td>%s</td><td>%s</td></tr>', app.app_id, app.app_name));
        }
      }
    });
  };
});
