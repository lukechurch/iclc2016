"use strict";

var ohm = require('ohm-js');
var fs = require('fs');
var ast_objects = require('./ast_objects');
var ast_semantics = require('./ast_semantics');
var contents = fs.readFileSync('grammar.ohm');
var grammar = ohm.grammar(contents);
var semantics = grammar.createSemantics().addOperation(ast_semantics.operation, ast_semantics.semantics);
var match = grammar.match('var sum = 1.0; var sum = x + y; at(1) {drawCircle(1,1,1);}');
// var match = grammar.match('var a = 3 > 2;');
// var match = grammar.match('drawCircle(x, y, radius);');
var result = semantics(match).toAST();
console.log(result.toJSONStringRecursive());

// console.log(grammar.trace('drawCircle(x, y, radius);').toString());
