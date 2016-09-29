// Primary data structures
class Line {
  int startX;
  int startY;
  int endX;
  int endY;
  int width;
  int r;
  int g;
  int b;
  int a;

  Line(this.startX, this.startY, this.endX, this.endY, this.width, this.r, this.g, this.b, this.a);
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
final Map<int, Circle> circles = <int, Circle>{};
final Map<int, Line> lines = <int, Line>{};

dynamic getObject(int id) {
  assert(idExists(id));

  if (circles.containsKey(id)) return circles[id];
  return lines[id];
}

deleteObject(int id) {
  assert(idExists(id));

  if (circles.containsKey(id)) circles.remove(id);
  if (lines.containsKey(id)) lines.remove(id);
}

int lastId = 0;
int allocateId() {
  return ++lastId;
}

bool idExists(int id) => circles.containsKey(id) || lines.containsKey(id);
