var gulp = require("gulp");
var path = require("path");
var gutil = require("gulp-util");
var webpack = require("webpack");
var settings = require("local_modules/settings");
var server = require("../../web/server");
var webpackDevServer = require("./webpack_dev_server")


module.exports = function (gulp) {
  var gutil = require('gulp-util');

  gulp.task("webpack", function(callback) {
    // run webpack
    webpack(config, function(err, stats) {
      if(err) throw new gutil.PluginError("webpack", err);
      gutil.log("[webpack]", stats.toString({
          // output options
      }));
      callback();
    });
  });

  gulp.task("webpack-dev-server", function(callback) {
    var port = settings.server.port
    // Start a webpack-dev-server
    webpackDevServer.listen(port)
    // ... and our main app server.
    server.start()
    console.log("Server is listening on http://127.0.0.1:" + port)
  });
}

