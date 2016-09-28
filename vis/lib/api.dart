import 'infra.dart';
import 'ui.dart';

// This file contains the public methods of the visulisation microservice

/// Create a new line, and return a handle to the line
int addLine(
  int startX, int startY,
  int endX, int endY,
  int r, int g, int b, int a) {

  int id = allocateId();
  assert (!idExists(id));

  var newLine = new Line(startX, startY, endX, endY, r, g, b, a);
  lines[id] = newLine;

  refreshDisplay();

  return id;
}

/// Create a new circle, and return a handle to the circle
int addCircle(
  int x, int y, int radius,
  int r, int g, int b, int a) {
  int id = allocateId();
  assert (!idExists(id));

  var newCircle = new Circle(x, y, radius, r, g, b, a);
  circles[id] = newCircle;

  refreshDisplay();

  return id;
}

/// Set the colour of a handle
bool setColour(int id,
  int r, int g, int b, int a) {

    if (!idExists(id)) return false;

    var obj = getObject(id);
    obj.r = r;
    obj.g = g;
    obj.b = b;
    obj.a = a;

    refreshDisplay();

    return true;
}

/// Detele the element associated with a handle
bool delete(int id) {
  if (!idExists(id)) return false;

  return deleteObject(id);
}
