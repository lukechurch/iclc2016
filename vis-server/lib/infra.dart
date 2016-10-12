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

class BezierCurve {
  int x1;
  int y1;
  int cx1;
  int cy1;
  int cx2;
  int cy2;
  int x2;
  int y2;
  int thickness;
  int r;
  int g;
  int b;
  int a;

  BezierCurve(this.x1, this.y1, this.cx1, this.cy1, this.cx2, this.cy2, this.x2, this.y2, this.thickness, this.r, this.g, this.b, this.a);
}

// TODO(Mariana): What's the right SVG type rep for these?
final Map<int, Circle> circles = <int, Circle>{};
final Map<int, Line> lines = <int, Line>{};
final Map<int, BezierCurve> bezierCurves = <int, BezierCurve>{};

dynamic getObject(int id) {
  assert(idExists(id));

  if (circles.containsKey(id)) return circles[id];
  if (bezierCurves.containsKey(id)) return bezierCurves[id];
  return lines[id];
}

deleteObject(int id) {
  assert(idExists(id));

  if (circles.containsKey(id)) circles.remove(id);
  if (lines.containsKey(id)) lines.remove(id);
  if (bezierCurves.containsKey(id)) bezierCurves.remove(id);
}

int lastId = 0;
int allocateId() {
  return ++lastId;
}

bool idExists(int id) => circles.containsKey(id) || lines.containsKey(id) || bezierCurves.containsKey(id);
