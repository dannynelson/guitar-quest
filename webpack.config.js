var path = require('path')
var webpack = require('webpack')

var webpackDevHost = 'localhost'

module.exports = function (webpackDevPort) {
  return {
    devtool: 'eval',
    entry: [
      'webpack-dev-server/client?http://' + webpackDevHost + ':' + webpackDevPort,
      'webpack/hot/only-dev-server',
      './react/index.jsx'
    ],
    output: {
      path: path.join(__dirname, 'dist'),
      filename: 'build/public/bundle.js',
      publicPath: 'http://' + webpackDevHost + ':' + webpackDevPort + '/static/'
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new webpack.NoErrorsPlugin()
    ],
    resolve: {
      extensions: ['', '.js', '.jsx']
    },
    module: {
      loaders: [{
        test: /\.jsx?$/,
        loaders: ['react-hot', 'babel'],
        include: path.join(__dirname, 'app')
      }]
    }
  }
}
