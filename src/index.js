'use strict';

require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('../elm-out/app.js');
var mountNode = document.getElementById('main');

var app = Elm.Elm.Main.init({
  node: mountNode,
  flags: {},
});