import 'dart:io' as io;

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import '../lib/live_runner.dart';
import 'package:iclc_config/config.dart' as config;


var server;

int _nextId = 0;
Map<int, LiveRunner> runners = {};

// Server that squares a number and returns it through RPC.
main() async {
  shelf_io.serve(webSocketHandler((webSocketChannel) {

    server = new json_rpc.Server(webSocketChannel)
      ..registerMethod('runSetupCode', (json_rpc.Parameters params) async {
        String src = params[0].asString;
        return {'result': runSetupCode(src)};
      })
      ..registerMethod('runBodyCode', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        String src = params[1].asString;
        runBodyCode(id, src);
        return {'result': 'ok'};
      })
      ..registerMethod('dispose', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        dispose(id);
        return {'result': 'ok'};
      })
      ..listen();
  }), io.InternetAddress.LOOPBACK_IP_V4, config.EXECUTION_SERVER_WS_PORT );
}

int runSetupCode(String src) {
  print ("runSetupCode");
  int execId = _nextId;
  _nextId++;
  var runner = new LiveRunner();
  runners[execId] = runner;
  runner.runSetupCode(src); // This does not block on the execution
  return execId;
}

runBodyCode(int id, String src) {
  print ("runBodyCode");

  if (!runners.containsKey(id)) throw "Unknown id: $id";
  runners[id]?.runBodyCode(src);
}

dispose(int id) {
  print ("dispose");

  runners.remove(id); // This will cause the execution to be gced
}
