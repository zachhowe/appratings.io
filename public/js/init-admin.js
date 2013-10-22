requirejs.config({
  baseUrl: 'js/lib',
  paths: {
    app: '../app'
  }
});

requirejs(
  ['jquery', 'sprintf', 'app/admin'],
  function ($, sprintf, admin) {
    admin.getAppList();

    $('#addAppButton').click(function() {
      var app_id = $('#app_id').val();

      admin.addApp(app_id);
    });
  }
);
