# How to run with Node.js

## 1. Install Node.js

From https://nodejs.org/en/download/ download Node.js and follow the
instructions there to install it.

## 2. Install the Ohm parser

The grammar for Molly is defined using the Ohm language. To install the Ohm/JS
library (which provides the JavaScript interface) for creating parsers, run the
following in this folder on your machine (i.e. iclc2016/parser/):

~~~~
npm install ohm-js
~~~~

## 3. Run the test file

~~~~
node test.js
~~~~

## Sample program

```
var x = 100;
var y = 50;
var radius = 10;
while(x > 0) {
  drawCircle(x, y, radius);
  x = x - 10;
}
```

```
{program: {statements: [{variableDeclaration: {identifier: {variable: x}, value: {int: 100}}}, {variableDeclaration: {identifier: {variable: y}, value: {int: 50}}}, {variableDeclaration: {identifier: {variable: radius}, value: {int: 10}}}, {whileLoop: {condition: {binaryOperation: {operation: >, lhs: {variable: x}, rhs: {int: 0}}}, statements: [{call: {receiver: {variable: drawCircle}, args: [{variable: x}, {variable: y}, {variable: radius}]}}, {variableAssignment: {identifier: {variable: x}, value: {binaryOperation: {operation: -, lhs: {variable: x}, rhs: {int: 10}}}}}]}}]}}
```
