import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:iclc_config/config.dart' as config;

json_rpc.Client client;

// Server that squares a number and returns it through RPC.
main() async {
  Uri serverURL = Uri.parse('ws://localhost:${config.API_SERVER_PORT}');
  var socket = new IOWebSocketChannel.connect(serverURL);
  client = new json_rpc.Client(socket)
    ..listen();

  addLine();
}


Future<int> addLine() async {
  Map json = await client.sendRequest('addLine', [300, 300, 400, 600, 2, 255, 0, 0, 255]);
  return json['result'];
}
