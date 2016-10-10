library ops_intrinsics_replacer;

Map correspondences = {
  "+": "intrinsics.add",
  "-": "intrinsics.sub",
  "*": "intrinsics.mul",
  "/": "intrinsics.div",
};

processAST(ast) {
  // Walk over the AST and if coming across a "binaryOperation", replace it with
  // a "call" expression.
  if (ast is Map) {
    if (ast.keys.length != 1) { // it's not a binaryOperation.
      ast.forEach((key, value) => processAST(value));
    } else if (ast.keys.first == "binaryOperation") { // it's a binaryOperation
        var binaryOpValue = ast["binaryOperation"];
        if (correspondences.keys.contains(binaryOpValue["operation"])) { // it an operation that can be replaced with intrinsics
          var callValue = {
            "receiver": {
              "variable": correspondences[binaryOpValue["operation"]],
            },
            "args": [
              binaryOpValue["lhs"],
              binaryOpValue["rhs"],
            ]
          };
          ast["call"] = callValue;
          ast.remove("binaryOperation");
          processAST(callValue);
        } else {
          processAST(binaryOpValue);
        }
    } else {
      processAST(ast[ast.keys.first]); // process whatever operation is here
    }
  } else if (ast is List) {
    for (var astNode in ast) {
      processAST(astNode);
    }
  } else {}
}
