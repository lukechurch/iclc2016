"use strict";

var ohm = require('ohm-js');
var fs = require('fs');
var ast_objects = require('./ast_objects');
var ast_semantics = require('./ast_semantics');
var contents = fs.readFileSync('grammar.ohm');
var grammar = ohm.grammar(contents);
var semantics = grammar.createSemantics().addOperation('toAST', ast_semantics.semantics);
var match = grammar.match('var x = 100;\nvar y = 50;var radius = 10;while(x > 0) {drawCircle(x, y, radius); x = x - 10;}');
// var match = grammar.match('var a = 3 > 2;');
// var match = grammar.match('drawCircle(x, y, radius);');
var result = semantics(match).toAST();
console.log(result.toJSONStringRecursive());

// console.log(grammar.trace('drawCircle(x, y, radius);').toString());
