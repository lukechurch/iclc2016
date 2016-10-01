import 'dart:io';
import 'dart:async';
import 'dart:convert' show UTF8, JSON;

Future main() async {
  String sampleProgram = '''
    var x = 100;
    var y = 50;
    var radius = 10;
    while(x > 0) {
      drawCircle(x, y, radius);
      x = x - 10;
    }''';

  var host = '127.0.0.1';
  var port = 8080;
  var path = '/generate_ast';

  var request = await new HttpClient().post(host, port, path);
  request.headers.contentType = ContentType.JSON;
  request.write(JSON.encode({'code': sampleProgram}));
  HttpClientResponse response = await request.close();
  await for (var contents in response.transform(UTF8.decoder)) {
    print('AST received: $contents');
  }
}
