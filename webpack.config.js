var ExtractTextPlugin = require( 'extract-text-webpack-plugin' );

module.exports = {
  entry: './src/index.js',

  output: {
    path: './dist',
    filename: 'index.js'
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      }
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    inline: true,
    stats: 'errors-only'
  },

  plugins: [
    // extract CSS into a separate file
    new ExtractTextPlugin( './css/stylesheet.css', { allChunks: true } )
  ]
};
