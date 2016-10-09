"use strict";

var ast = require('./ast_objects');
var operation = "toAST";
var semantics = {
  Program: function(statements) {
    return new ast.Program(statements.toAST());
  },

  Statement_varDeclaration: function(_var, identifier, _eq, expression, _semicolon) {
    return new ast.VariableDeclaration(identifier.toAST(), expression.toAST());
  },

  Statement_varAssignment: function(identifier, _eq, expression, _semicolon) {
    return new ast.VariableAssignment(identifier.toAST(), expression.toAST());
  },

  Statement_whileLoop: function(_while, _openParen, condition, _closeParen, _openBracket, statements, _closeBracket) {
    return new ast.WhileLoop(condition.toAST(), statements.toAST());
  },

  Statement_expression: function(expression, _semicolon) {
    return expression.toAST();
  },

  EqualityExpression_eq: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  EqualityExpression_neq: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  RelationalExpression_lt: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  RelationalExpression_gt: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  RelationalExpression_le: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  RelationalExpression_ge: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  AdditiveExpression_add: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  AdditiveExpression_sub: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  MultiplicativeExpression_mul: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  MultiplicativeExpression_div: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  MultiplicativeExpression_mod: function(x, op, y) {
    return new ast.BinaryOperation(op.sourceString, x.toAST(), y.toAST());
  },

  UnaryExpression_unaryMinus: function(op, x) {
    return new ast.UnaryOperation(op.sourceString, x.toAST());
  },

  UnaryExpression_callExp: function(call) {
    return call.toAST();
  },

  UnaryExpression_primExp: function(exp) {
    return exp.toAST();
  },

  CallExpression_callExpExp: function(receiver, args) {
    return new ast.Call(receiver.toAST(), args.toAST());
  },

  CallExpression_primExpExp: function(exp) {
    return exp.toAST();
  },

  Arguments: function(_openParen, args, _closeParen) {
    return args.toAST();
  },

  PrimaryExpression_identifier: function(x) {
    return x.toAST();
  },

  PrimaryExpression_literal: function(x) {
    return x.toAST();
  },

  PrimaryExpression_paren: function(_openParen, x, _closeParen) {
    return x.toAST();
  },

  identifier: function(x) {
    return new ast.Var(this.sourceString);
  },

  booleanLiteral: function(x) {
    return new ast.Boolean(this.sourceString === "true");
  },

  intLiteral: function(x) {
    return new ast.Integer(parseInt(this.sourceString));
  },

  floatLiteral: function(a, _dot, b) {
    return new ast.Float(parseFloat(this.sourceString));
  },

  stringLiteral: function(_openQuote, x, _closeQuote) {
    return new ast.String(this.sourceString);
  },

  NonemptyListOf: function(arg, _separator, args) {
    return [arg.toAST()].concat(args.toAST());
  },

  EmptyListOf: function() {
    return [];
  }
};

module.exports = {
  operation: operation,
  semantics: semantics,
};
