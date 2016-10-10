import 'dart:io';
import 'dart:async';
import 'dart:convert' show UTF8, JSON;

import 'package:ops_intrinsics_replacer/ops-intrinsincs-replacer.dart' as opsreplacer;

Future main() async {
  String sampleProgram = '''
    var x = 100 + 67;
    var y = 50 * 3;
    var radius = x - y;
    while(x > 0) {
      drawCircle(x, y + 5, radius);
      x = x - 10;
    }''';
  String expectedAST_JSON = '{"program":{"statements":[{"variableDeclaration":{"identifier":{"variable":"x"},"value":{"binaryOperation":{"operation":"+","lhs":{"int":100},"rhs":{"int":67}}}}},{"variableDeclaration":{"identifier":{"variable":"y"},"value":{"binaryOperation":{"operation":"*","lhs":{"int":50},"rhs":{"int":3}}}}},{"variableDeclaration":{"identifier":{"variable":"radius"},"value":{"binaryOperation":{"operation":"-","lhs":{"variable":"x"},"rhs":{"variable":"y"}}}}},{"whileLoop":{"condition":{"binaryOperation":{"operation":">","lhs":{"variable":"x"},"rhs":{"int":0}}},"statements":[{"call":{"receiver":{"variable":"drawCircle"},"args":[{"variable":"x"},{"binaryOperation":{"operation":"+","lhs":{"variable":"y"},"rhs":{"int":5}}},{"variable":"radius"}]}},{"variableAssignment":{"identifier":{"variable":"x"},"value":{"binaryOperation":{"operation":"-","lhs":{"variable":"x"},"rhs":{"int":10}}}}}]}}]}}';
  String expectedProcessedAST_JSON = '{"program":{"statements":[{"variableDeclaration":{"identifier":{"variable":"x"},"value":{"call":{"receiver":{"variable":"intrinsics.add"},"args":[{"int":100},{"int":67}]}}}},{"variableDeclaration":{"identifier":{"variable":"y"},"value":{"call":{"receiver":{"variable":"intrinsics.mul"},"args":[{"int":50},{"int":3}]}}}},{"variableDeclaration":{"identifier":{"variable":"radius"},"value":{"call":{"receiver":{"variable":"intrinsics.sub"},"args":[{"variable":"x"},{"variable":"y"}]}}}},{"whileLoop":{"condition":{"call":{"receiver":{"variable":"intrinsics.gt"},"args":[{"variable":"x"},{"int":0}]}},"statements":[{"call":{"receiver":{"variable":"drawCircle"},"args":[{"variable":"x"},{"call":{"receiver":{"variable":"intrinsics.add"},"args":[{"variable":"y"},{"int":5}]}},{"variable":"radius"}]}},{"variableAssignment":{"identifier":{"variable":"x"},"value":{"call":{"receiver":{"variable":"intrinsics.sub"},"args":[{"variable":"x"},{"int":10}]}}}}]}}]}}';

  var host = '127.0.0.1';
  var port = 9080;
  var path = '/generate_ast';

  var request = await new HttpClient().post(host, port, path);
  request.headers.contentType = ContentType.JSON;
  request.write(JSON.encode({'code': sampleProgram}));
  HttpClientResponse response = await request.close();
  await for (var contents in response.transform(UTF8.decoder)) {
    var receivedAST = JSON.decode(contents);
    var receivedAST_JSON = JSON.encode(receivedAST); // just to make sure tests pass, as expectedAST and expectedProcessedAST have been generated with JSON.encode().
    if (receivedAST_JSON == expectedAST_JSON) {
      print('AST received matches expected:\n${expectedAST_JSON}');
    } else {
      print('AST received does not match!\nExpected:\n${expectedAST_JSON}\nReceived:\n${receivedAST_JSON}');
      return;
    }
    print('-----');
    opsreplacer.processAST(receivedAST);
    var processedAST_JSON = JSON.encode(receivedAST);
    if (processedAST_JSON == expectedProcessedAST_JSON) {
      print('AST processed matches expected:\n${expectedProcessedAST_JSON}');
    } else {
      print('AST processed does not match!\nExpected:\n${expectedProcessedAST_JSON}\Processed:\n${processedAST_JSON}');
      return;
    }
  }
}
