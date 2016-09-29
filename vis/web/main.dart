import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:iclc2016_vis/api.dart' as api;

import 'package:iclc2016_vis/ui.dart' as ui;

main() {
  // This should be done by the UI interface
  ui.initUI(html.querySelector('#visualisation-container'), 1000, 500);

  // These calls should be done by the client calling the API service
  int line = api.addLine(300, 300, 300, 500, 2, 255, 0, 0, 255);
  int flickeringCircle = api.addCircle(800, 100, 100, 234, 190, 97, 255);
  int x = 400, y = 100;
  int movingCircle = api.addCircle(x, y, 100, 234, 190, 97, 255);

  api.delete(line);

  math.Random rand = new math.Random();
  new Timer.periodic(new Duration(seconds:0), (_) {
    api.setColour(flickeringCircle, rand.nextInt(255), rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
    api.setCircleCoordinates(movingCircle, ++x, ++y);
  });
}