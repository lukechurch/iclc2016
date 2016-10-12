import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:iclc_config/config.dart' as config;


sub(x, y) => x - y;
add(x, y) => x + y;
div(x, y) => x / y;
mod(x, y) => x % y;
mul(x, y) => x * y;
not(x) => !x;
lt(x, y) => x < y;
gt(x, y) => x > y;
lteq(x, y) => x <= y;
gteq(x, y) => x >= y;
eq(x, y) => x == y;

json_rpc.Client client;

rpc_proxy(name, arguments) async {
  print ("Invoking rpc_proxy: $name ($arguments)");

  if (client == null) {
    Uri serverURL = Uri.parse('ws://localhost:${config.API_SERVER_PORT}');
    var socket = new IOWebSocketChannel.connect(serverURL);
    client = new json_rpc.Client(socket)
      ..listen();
  }

  var resultJson = await client.sendRequest(name, arguments);
  return resultJson['result'];
}
