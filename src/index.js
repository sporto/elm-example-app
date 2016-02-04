'use strict';

require('basscss/css/basscss.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountNode, {getDeleteConfirmation: 0});

app.ports.askForDeleteConfirmation.subscribe(function (args) {
  var id = args[0];
  var message = args[1];
  var response = window.confirm(message);
  if (response) {
    app.ports.getDeleteConfirmation.send(id);
  }
})
