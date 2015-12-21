var path = require('path')
var webpack = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var webpackDevHost = 'localhost'

module.exports = function (webpackDevPort) {
  return {
    devtool: 'eval',
    entry: [
      'webpack-dev-server/client?http://' + webpackDevHost + ':' + webpackDevPort,
      // 'webpack/hot/only-dev-server',
      './react/index.js'
    ],
    output: {
      path: path.join(__dirname, 'dist'),
      filename: 'app.js',
      publicPath: 'http://' + webpackDevHost + ':' + webpackDevPort + '/'
    },
    plugins: [
      new ExtractTextPlugin('app.css', { allChunks: true }),
      // new webpack.HotModuleReplacementPlugin(),
      new webpack.NoErrorsPlugin()
    ],
    resolve: {
      extensions: ['', '.js', '.jsx', '.css']
    },
    postcss: [
      require('autoprefixer-core'),
      require('postcss-color-rebeccapurple')
    ],
    module: {
      loaders: [
        {
          test: /\.jsx?$/,
          loader: 'babel?presets[]=react,presets[]=es2015',
          include: [
            path.join(process.cwd(), 'react'),
            path.join(process.cwd(), 'local_modules')
          ]
        },
        {
          test: /\.css$/,
          // loader: 'style-loader!css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]!postcss-loader'
          loader: ExtractTextPlugin.extract('style-loader', 'css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]!postcss-loader')
        }
      ]
    }
  }
}
