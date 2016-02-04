'use strict';

require('basscss/css/basscss.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountNode, {getConfirmation: false});

app.ports.askForConfirmation.subscribe(function (message) {
  var response = window.confirm(message);
  if (response) {
    console.log('response true')
    app.ports.getConfirmation.send(true)
  }
})
