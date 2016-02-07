var webpack = require('webpack');
var WebpackDevServer = require('webpack-dev-server');
var config = require('./webpack.config')
var compiler = webpack(config);

var server = new WebpackDevServer(compiler, {
  inline: true,
  stats: {colors: true}
});


server.listen(3000, 'localhost');
