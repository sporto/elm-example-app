'use strict';

require('basscss/css/basscss.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// The third value on embed are the initial values for incomming ports into Elm
var app = Elm.embed(Elm.Main, mountNode, {getDeleteConfirmation: 0});

// askForDeleteConfirmation is called by sending a message to a port in elm
// When this is called the browser will show a confirmation window
// If the user responds with yes then we send a message back to Elm
app.ports.askForDeleteConfirmation.subscribe(function (args) {
  var id = args[0];
  var message = args[1];
  var response = window.confirm(message);
  if (response) {
    app.ports.getDeleteConfirmation.send(id);
  }
})
