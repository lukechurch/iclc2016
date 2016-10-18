import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:convert';
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
        int startX = params[0].asNum;
        int startY = params[1].asNum;
        int endX = params[2].asNum;
        int endY = params[3].asNum;
        int thickness = params[4].asNum;
        int r = params[5].asInt;
        int g = params[6].asInt;
        int b = params[7].asInt;
        int a = params[8].asInt;
        print ("addLine: $startX $startY $endX $endY");

        return {'result': api.addLine(startX, startY, endX, endY, thickness, r, g, b, a)};
      })
      ..registerMethod('addCircle', (json_rpc.Parameters params) async {
        int x = params[0].asNum;
        int y = params[1].asNum;
        int radius = params[2].asNum;
        int r = params[3].asInt;
        int g = params[4].asInt;
        int b = params[5].asInt;
        int a = params[6].asInt;
        print ("addCirclr: $x $y $radius");

        return {'result': api.addCircle(x, y, radius, r, g, b, a)};
      })
      ..registerMethod('addBezierCurve', (json_rpc.Parameters params) async {
        int x1 = params[0].asNum;
        int y1 = params[1].asNum;
        int cx1 = params[2].asNum;
        int cy1 = params[3].asNum;
        int cx2 = params[4].asNum;
        int cy2 = params[5].asNum;
        int x2 = params[6].asNum;
        int y2 = params[7].asNum;
        int thickness = params[8].asNum;
        int r = params[9].asInt;
        int g = params[10].asInt;
        int b = params[11].asInt;
        int a = params[12].asInt;
        print ("addBezierCurve: $x1 $y1 $cx1 $cy1 $cx2 $cy2 $x2 $y2");

        return {'result': api.addBezierCurve(x1, y1, cx1, cy1, cx2, cy2, x2, y2, thickness, r, g, b, a)};
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
        int startX = params[1].asNum;
        int startY = params[2].asNum;
        int endX = params[3].asNum;
        int endY = params[4].asNum;
        return {'result': api.setLineCoordinates(id, startX, startY, endX, endY)};
      })
      ..registerMethod('setCircleCoordinates', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        int x = params[1].asNum;
        int y = params[2].asNum;
        return {'result': api.setCircleCoordinates(id, x, y)};
      })
      ..registerMethod('setBezierCurveCoordinates', (json_rpc.Parameters params) async {
        int id = params[0].asInt;
        int x1 = params[1].asNum;
        int y1 = params[2].asNum;
        int cx1 = params[3].asNum;
        int cy1 = params[4].asNum;
        int cx2 = params[5].asNum;
        int cy2 = params[6].asNum;
        int x2 = params[7].asNum;
        int y2 = params[8].asNum;
        return {'result': api.setBezierCurveCoordinates(id, x1, y1, cx1, cy1, cx2, cy2, x2, y2)};
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
      ..registerMethod('getBezierCurves', (json_rpc.Parameters params) async {
        return {'result': getBezierCurves()};
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
      ..registerMethod('floor', (json_rpc.Parameters params) async {
        double x = params[0].asNum;
        return {'result': floor(x)};
      })
      ..registerMethod('random', (json_rpc.Parameters params) async {
        return {'result': random()};
      })
      ..registerMethod('clear', (json_rpc.Parameters params) async {
        clear();
        return {'result': "ok"};
      })
      ..listen();
  }), io.InternetAddress.LOOPBACK_IP_V4, config.API_SERVER_PORT);
}

clear() {
  print ("clearing lines: ${infra.lines.length} circles: ${infra.circles.length}");
  infra.lines.clear();
  infra.circles.clear();
  print ("lines: ${infra.lines.length} circles: ${infra.circles.length}");
}

Map getCircles() {
  Map circles = {};
  infra.circles.forEach((k, v) {
    circles["$k"] = {
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
    lines["$k"] = {
      "startX" : v.startX,
      "startY" : v.startY,
      "endX" : v.endX,
      "endY" : v.endY,
      "thickness": v.thickness,
      "r" : v.r,
      "g" : v.g,
      "b" : v.b,
      "a" : v.a,
    };
  });

  return lines;
}

Map getBezierCurves() {
  Map bezierCurves = {};
  infra.bezierCurves.forEach((k, v) {
    bezierCurves["$k"] = {
      "x1" : v.x1,
      "y1" : v.y1,
      "cx1" : v.cx1,
      "cy1" : v.cy1,
      "cx2" : v.cx2,
      "cy2" : v.cy2,
      "x2" : v.x2,
      "y2" : v.y2,
      "thickness": v.thickness,
      "r" : v.r,
      "g" : v.g,
      "b" : v.b,
      "a" : v.a,
    };
  });

  return bezierCurves;
}



double sin(double x) => math.sin(x);
double cos(double x) => math.cos(x);
double tan(double x) => math.tan(x);
double sqrt(double x) => math.sqrt(x);
int floor(double x) => x.floor();

math.Random _random = new math.Random(10);
double random() => _random.nextDouble();
