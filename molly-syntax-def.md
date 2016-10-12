# The Molly Programming Language

## Syntax
### Variable declaration

OK:
```
var a = 12;
var b;
```

Not OK:
```
var a = 12, b;
```


### Operations supported

`+`, `-`, `*`, `/`, `%`, `<`, `<=`, `>`, `>=`, `==`


### Types

`int`, `float`, `boolean`, `string`


### While loops

Example:
```
var a = 10;
while(a > 0) {
	a = a - 1;
}
```

## Visualisation API

```
int addLine(
  int startX, int startY,
  int endX, int endY,
  int thickness,
  int r, int g, int b, int a)
```

Adds a new line on the screen. Returns the `id` of the line.

---

```
int addCircle(
  int x, int y, int radius,
  int r, int g, int b, int a)
```

Adds a new circle on the screen. Returns the `id` of the line.

---

```
bool setColour(int id, int r, int g, int b, int a);
```

Sets the colour of the shape with the given `id`.

---

```
bool setLineCoordinates(int id,
  int startX, int startY,
  int endX, int endY)
```

Sets the coordinates of the line with the given `id`.

---

```
bool setCircleCoordinates(int id, int x, int y)
```
Sets the coordinates of the circle with the given `id`.

---

```
bool delete(int id)
```
Deletes the shape with the given `id`.

---
