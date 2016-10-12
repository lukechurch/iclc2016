import 'infra.dart';

// This file contains the public methods of the visulisation microservice

/// Create a new line, and return a handle to the line
int addLine(
  int startX, int startY,
  int endX, int endY,
  int thickness,
  int r, int g, int b, int a) {

  int id = allocateId();
  assert (!idExists(id));

  var newLine = new Line(startX, startY, endX, endY, thickness, r, g, b, a);
  lines[id] = newLine;

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

    return true;
}

/// Set the coordinates of a line handle
bool setLineCoordinates(int id,
  int startX, int startY,
  int endX, int endY) {

    if (!idExists(id)) return false;

    var obj = getObject(id);
    if (obj is! Line) return false;

    obj.startX = startX;
    obj.startY = startY;
    obj.endX = endX;
    obj.endY = endY;

    return true;
}

/// Set the coordinates of a circle handle
bool setCircleCoordinates(int id, int x, int y) {

    if (!idExists(id)) return false;

    var obj = getObject(id);
    if (obj is! Circle) return false;

    obj.x = x;
    obj.y = y;

    return true;
}


/// Detele the element associated with a handle
bool delete(int id) {
  if (!idExists(id)) return false;

  bool deleted = deleteObject(id);

  return deleted;
}
