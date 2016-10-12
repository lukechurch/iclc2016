
// TODO: Replace the implementation of parse with a JSON-RPC call

import 'dart:async';
import 'dart:convert' show UTF8, JSON;
import 'dart:io';
import 'package:iclc_config/config.dart' as config;


var host = '127.0.0.1';
var port = config.PARSER_SERVER_PORT;
var path = '/generate_ast';
var client;

Future<Map> parse(String src) async {
  client = client ?? new HttpClient();
  var request = await client.post(host, port, path);
  request.headers.contentType = ContentType.JSON;
  request.write(JSON.encode({'code': src}));
  await request.flush();

  HttpClientResponse response = await request.close();

  String strResponse = await response.transform(UTF8.decoder).join();

  return JSON.decode(strResponse);
}
