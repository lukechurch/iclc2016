# How to run the parser over HTTP demo

## 1. Install express and body-parser

~~~~
npm install express --save
npm install body-parser --save
~~~~

## 2. Run server-demo.js from a terminal window

~~~~
node server-demo.js
~~~~

## 3. Run runner.dart from another terminal window

~~~~
dart bin/runner.dart
~~~~

### In the dart terminal window you should see:

~~~~
AST received: {"program": {"statements": [...]
~~~~
