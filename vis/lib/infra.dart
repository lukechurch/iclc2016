import 'dart:html';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/html.dart';
import 'package:iclc_config/config.dart' as config;


// Primary data structures
class Line {
  int startX;
  int startY;
  int endX;
  int endY;
  int thickness;
  int r;
  int g;
  int b;
  int a;

  Line(this.startX, this.startY, this.endX, this.endY, this.thickness, this.r, this.g, this.b, this.a);
}

class Circle {
  int x;
  int y;
  int radius;
  int r;
  int g;
  int b;
  int a;

  Circle(this.x, this.y, this.radius, this.r, this.g, this.b, this.a);
}


// TODO(Mariana): What's the right SVG type rep for these?
Map<int, Circle> circles = <int, Circle>{};
Map<int, Line> lines = <int, Line>{};

var apiClient;

setupApiClient() {
  Uri serverURL = Uri.parse('ws://localhost:${config.API_SERVER_PORT}');
  var socket = new HtmlWebSocketChannel.connect(serverURL);
  apiClient = new json_rpc.Client(socket)..listen();
}

clear() async {
  await apiClient.sendRequest('clear', []);
}

updateModel() async {
  if (apiClient == null) {
    print ("apiClient is null, skipping update");
    return;
  }

  var result = await apiClient.sendRequest('getCircles', []);
  Map circlesMap = result['result'];
  Map<int, Circle> newCircles = <int, Circle>{};
  circlesMap.forEach((k, v) {
    newCircles[int.parse(k)] = new Circle(
      v["x"], v["y"], v["radius"], v["r"], v["g"], v["b"], v["a"]);
  });
  circles = newCircles;

  Map<int, Line> newLines = <int, Line>{};
  var linesResult = await apiClient.sendRequest('getLines', []);
  Map linesMap = linesResult['result'];
  linesMap.forEach((k, v) {
    newLines[int.parse(k)] = new Line(
      v["startX"], v["startY"], v["endX"], v["endY"],
      v["thickness"], v["r"], v["g"], v["b"], v["a"]);
  });

  lines = newLines;
}
