requirejs.config({
  baseUrl: 'js/lib',
  paths: {
    app: '../app'
  },
  shim: {
    "highcharts": {
      "exports": "Highcharts",
      "deps": [ "jquery"] 
    },
  }
});

requirejs(
  ['jquery', 'sprintf', 'highcharts', 'app/main'],
  function ($, chart, sprintf, highcharts, main) {
    $("#app_icon").hide();

    main.getAppList();

    $('#loadAppButton').click(function() {
      var app_id = $('#app_id').val();

      main.loadApp(app_id);
    });
  }
);
