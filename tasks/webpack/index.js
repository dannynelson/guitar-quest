var gulp = require("gulp");
var path = require("path");
var gutil = require("gulp-util");
var webpack = require("webpack");
var WebpackDevServer = require("webpack-dev-server")


module.exports = function (gulp) {
  var gutil = require('gulp-util');

  var config = {
    context: process.cwd() + "/react",
    watch: (gutil.env.prod ? false : true),
    devtool: 'cheap-module-eval-source-map',
    entry: [
      'webpack-hot-middleware/client',
      './index'
    ],
    output: {
      path: path.join(process.cwd(), 'build', 'public'),
      filename: 'app.js',
      publicPath: '/'
    },
    plugins: [
      new webpack.optimize.OccurenceOrderPlugin(),
      new webpack.HotModuleReplacementPlugin(),
      new webpack.NoErrorsPlugin()
    ],
    module: {
      loaders: [{
        test: /\.js$/,
        loaders: [ 'babel?presets[]=react,presets[]=es2015' ],
        exclude: /node_modules/,
        include: process.cwd() + "/react",
      }, {
        test: /\.css?$/,
        loaders: [ 'style', 'raw' ],
        include: process.cwd() + "/react"
      }]
    }
  }

  gulp.task("webpack", function(callback) {
    // run webpack
    webpack(config, function(err, stats) {
      if(err) throw new gutil.PluginError("webpack", err);
      gutil.log("[webpack]", stats.toString({
          // output options
      }));
      if (gutil.env.prod) callback();
    });
  });

  gulp.task("webpack-dev-server", function(callback) {
    // Start a webpack-dev-server
    var compiler = webpack(config);

    new WebpackDevServer(compiler, {
        // server and middleware options
    }).listen(8080, "localhost", function(err) {
        if(err) throw new gutil.PluginError("webpack-dev-server", err);
        // Server listening
        gutil.log("[webpack-dev-server]", "http://localhost:8080/webpack-dev-server/index.html");

        // keep the server alive or continue?
        // callback();
    });
  });
}

