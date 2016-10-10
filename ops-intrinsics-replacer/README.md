# A library to replace arithmetic operations with intrinsics

The example first makes a call to the parser to get the AST, and then calls the ops-intrinsincs-replacer library (this library).

## Run the example

In order to run the example, first you need to run the parser server (from iclc2016/parser/):

```node server-demo.js```

Then run the example (from iclc/ops-intrinsics-replacer/):

```dart bin/example.dart```

The output should be:

```
AST received matches expected:
{"program":{"statements":[{"variableDeclaration":{"identifier":{"variable":"x"},"value":{"binaryOperation":{"operation":"+","lhs":{"int":100},"rhs":{"int":67}}}}},{"variableDeclaration":{"identifier":{"variable":"y"},"value":{"binaryOperation":{"operation":"*","lhs":{"int":50},"rhs":{"int":3}}}}},{"variableDeclaration":{"identifier":{"variable":"radius"},"value":{"binaryOperation":{"operation":"-","lhs":{"variable":"x"},"rhs":{"variable":"y"}}}}},{"whileLoop":{"condition":{"binaryOperation":{"operation":">","lhs":{"variable":"x"},"rhs":{"int":0}}},"statements":[{"call":{"receiver":{"variable":"drawCircle"},"args":[{"variable":"x"},{"binaryOperation":{"operation":"+","lhs":{"variable":"y"},"rhs":{"int":5}}},{"variable":"radius"}]}},{"variableAssignment":{"identifier":{"variable":"x"},"value":{"binaryOperation":{"operation":"-","lhs":{"variable":"x"},"rhs":{"int":10}}}}}]}}]}}
-----
AST processed matches expected:
{"program":{"statements":[{"variableDeclaration":{"identifier":{"variable":"x"},"value":{"call":{"receiver":{"variable":"intrinsics.add"},"args":[{"int":100},{"int":67}]}}}},{"variableDeclaration":{"identifier":{"variable":"y"},"value":{"call":{"receiver":{"variable":"intrinsics.mul"},"args":[{"int":50},{"int":3}]}}}},{"variableDeclaration":{"identifier":{"variable":"radius"},"value":{"call":{"receiver":{"variable":"intrinsics.sub"},"args":[{"variable":"x"},{"variable":"y"}]}}}},{"whileLoop":{"condition":{"binaryOperation":{"operation":">","lhs":{"variable":"x"},"rhs":{"int":0}}},"statements":[{"call":{"receiver":{"variable":"drawCircle"},"args":[{"variable":"x"},{"call":{"receiver":{"variable":"intrinsics.add"},"args":[{"variable":"y"},{"int":5}]}},{"variable":"radius"}]}},{"variableAssignment":{"identifier":{"variable":"x"},"value":{"call":{"receiver":{"variable":"intrinsics.sub"},"args":[{"variable":"x"},{"int":10}]}}}}]}}]}}
```
