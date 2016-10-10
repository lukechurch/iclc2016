"use strict";

// Grab the packages needed
var ohm = require('ohm-js');
var fs = require('fs');
var express = require('express');
var bodyParser = require('body-parser');

// Grab the local files needed
var ast_objects = require('./ast_objects');
var ast_semantics = require('./ast_semantics');

// Set up the semantics for the grammar
var contents = fs.readFileSync('grammar.ohm');
var grammar = ohm.grammar(contents);
var semantics = grammar.createSemantics().addOperation(ast_semantics.operation, ast_semantics.semantics);

// Create an HTTP server
var app = express();
var port = 9080;
var path = '/generate_ast';

app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

app.post(path, function(req, res) {
  console.log('Code to process: ' + req.body.code);
  var codeMatch = grammar.match(req.body.code);
  var codeSemantics = semantics(codeMatch).toAST();
  res.send(codeSemantics.toJSONStringRecursive());
});

// start the server
app.listen(port);
console.log('Server started! At http://localhost:' + port);
