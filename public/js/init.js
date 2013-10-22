requirejs.config({
  baseUrl: 'js/lib',
  paths: {
    app: '../app'
  }
});

requirejs(
  ['jquery', 'chart', 'sprintf', 'app/main'],
  function ($, chart, sprintf, main) {
    $("#app_icon").hide();
    
    main.getAppList();

    $('#loadAppButton').click(function() {
      var app_id = $('#app_id').val();

      main.loadApp(app_id);
    });
  }
);
