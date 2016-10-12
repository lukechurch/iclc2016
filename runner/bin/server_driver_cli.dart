import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import '../../config.dart' as config;

json_rpc.Client client;

final trivialSetupProgram = '''
  var x = 100;
  var y = 50;
  var radius = 10;
  ''';

final bodyCode = '''
radius = radius / 2;
drawCircle(x, y, radius + 2);
''';

// Server that squares a number and returns it through RPC.
main() async {
  Uri serverURL = Uri.parse('ws://localhost:${config.EXECUTION_SERVER_WS_PORT}');
  var socket = new IOWebSocketChannel.connect(serverURL);
  client = new json_rpc.Client(socket)
    ..listen();

  print ("About to send setup code");
  int id = await runSetupCode(trivialSetupProgram);
  print ("Setup complete");

  await new Future.delayed(new Duration(seconds: 1));

  for (int i = 0; i < 200; i++) {
    print ("About to run body code");
    await runBodyCode(id, bodyCode);
    await new Future.delayed(new Duration(milliseconds: 200));
  }

  print ("Completed, about to dispose");
  await dispose(id);
}


Future<int> runSetupCode(String src) async {
  Map json = await client.sendRequest('runSetupCode', [src]);
  return json['result'];
}

Future runBodyCode(int id, String src) async {
  await client.sendRequest('runBodyCode', [id, src]);
}

Future dispose(int id) async {
  await client.sendRequest('dispose', [id]);
}
