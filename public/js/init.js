requirejs.config({
  baseUrl: 'js/lib',
  paths: {
    app: '../app'
  }
});

requirejs(
  ['jquery', 'chart', 'sprintf', 'app/main'],
  function ($, chart, sprintf, main) {
    getAppList();
  }
);
