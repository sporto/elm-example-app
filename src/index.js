'use strict';

require('basscss/css/basscss.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

Elm.embed(Elm.Main, mountNode);
