import 'dart:io' as io;
import 'dart:math' as math;
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import '../lib/api.dart' as api;
import '../lib/infra.dart' as infra;
import 'package:iclc_config/config.dart' as config;


var server;

// API Server
main() async {
  shelf_io.serve(webSocketHandler((webSocketChannel) {

    server = new json_rpc.Server(webSocketChannel)
      ..registerMethod('addLine', (json_rpc.Parameters params) async {
        int startX = params[0].asInt;
        int startY = params[1].asInt;
        int endX = params[2].asInt;
        int endY = params[3].asInt;
        int thickness = params[4].asInt;
        int r = params[5].asInt;
        int g = params[6].asInt;
        int b = params[7].asInt;
        int a = params[8].asInt;
        return {'result': api.addLine(startX, startY, endX, endY, thickness, r, g, b, a)};
      })
      ..registerMethod('addCircle', (json_rpc.Parameters params) async {
        int x = params[0].asInt;
        int y = params[1].asInt;
        int radius = params[2].asInt;
        int r = params[3].asInt;
        int g = params[4].asInt;
        int b = params[5].asInt;
        int a = params[6].asInt;
        return {'result': api.addCircle(x, y, radius, r, g, b, a)};
      })
      ..registerMethod('setColour', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        int r = params[1].asInt;
        int g = params[2].asInt;
        int b = params[3].asInt;
        int a = params[4].asInt;
        return {'result': api.setColour(id, r, g, b, a)};
      })
      ..registerMethod('setLineCoordinates', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        int startX = params[1].asInt;
        int startY = params[2].asInt;
        int endX = params[3].asInt;
        int endY = params[4].asInt;
        return {'result': api.setLineCoordinates(id, startX, startY, endX, endY)};
      })
      ..registerMethod('setCircleCoordinates', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        int x = params[1].asInt;
        int y = params[2].asInt;
        return {'result': api.setCircleCoordinates(id, x, y)};
      })
      ..registerMethod('delete', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        return {'result': api.delete(id)};
      })
      ..registerMethod('getCircles', (json_rpc.Parameters params) async {
        return {'result': getCircles()};
      })
      ..registerMethod('getLines', (json_rpc.Parameters params) async {
        return {'result': getLines()};
      })
      ..registerMethod('sin', (json_rpc.Parameters params) async {
        double x = params[0].asNum;
        return {'result': sin(x)};
      })
      ..registerMethod('cos', (json_rpc.Parameters params) async {
        double x = params[0].asNum;
        return {'result': cos(x)};
      })
      ..registerMethod('tan', (json_rpc.Parameters params) async {
        double x = params[0].asNum;
        return {'result': tan(x)};
      })
      ..registerMethod('sqrt', (json_rpc.Parameters params) async {
        double x = params[0].asNum;
        return {'result': sqrt(x)};
      })
      ..registerMethod('random', (json_rpc.Parameters params) async {
        return {'result': random()};
      })
      ..listen();
  }), io.InternetAddress.LOOPBACK_IP_V4, config.API_SERVER_PORT);
}

Map getCircles() {
  Map circles = {};
  infra.circles.forEach((k, v) {
    circles[k] = {
      "x" : v.x,
      "y" : v.y,
      "radius" : v.radius,
      "r" : v.r,
      "g" : v.g,
      "b" : v.b,
      "a" : v.a,
    };
  });

  return circles;
}

Map getLines() {
  Map lines = {};
  infra.lines.forEach((k, v) {
    lines[k] = {
      "startX" : v.startX,
      "startY" : v.startY,
      "endX" : v.endX,
      "endY" : v.endY,
      "r" : v.r,
      "g" : v.g,
      "b" : v.b,
      "a" : v.a,
    };
  });

  return lines;
}

double sin(double x) => math.sin(x);
double cos(double x) => math.cos(x);
double tan(double x) => math.tan(x);
double sqrt(double x) => math.sqrt(x);

math.Random _random = new math.Random(10);
double random() => _random.nextDouble();
