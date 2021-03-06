import 'dart:html' as html;
import 'dart:svg' as svg;

import 'infra.dart' as infra;

svg.SvgSvgElement _svgContainer;

initUI(html.Element parent, int width, int height) {
  _svgContainer = new svg.SvgSvgElement()
    ..attributes['width'] = '$width'
    ..attributes['height'] = '$height';
  parent.append(_svgContainer);
}

Map<int, svg.SvgElement> idToElementMap = {};

refreshDisplay() {
  if (_svgContainer == null) {
    return;
  }

  List<int> idsToRemove = idToElementMap.keys.toList();

  infra.circles.forEach((id, circle) {
    idsToRemove.remove(id);
    if (idToElementMap.containsKey(id)) {
      idToElementMap[id]
        ..attributes['r'] = '${circle.radius}'
        ..attributes['cx'] = '${circle.x}'
        ..attributes['cy'] = '${circle.y}'
        ..attributes['fill'] = 'rgba(${circle.r}, ${circle.g}, ${circle.b}, ${circle.a/255.0})';
    } else {
      svg.CircleElement svgCircle = new svg.CircleElement()
        ..attributes['id'] = '$id'
        ..attributes['r'] = '${circle.radius}'
        ..attributes['cx'] = '${circle.x}'
        ..attributes['cy'] = '${circle.y}'
        ..attributes['fill'] = 'rgba(${circle.r}, ${circle.g}, ${circle.b}, ${circle.a/255.0})';
      idToElementMap[id] = svgCircle;
      _svgContainer.append(svgCircle);
    }

  });

  infra.lines.forEach((id, line) {
    idsToRemove.remove(id);
    if (idToElementMap.containsKey(id)) {
      idToElementMap[id]
        ..attributes['x1'] = '${line.startX}'
        ..attributes['y1'] = '${line.startY}'
        ..attributes['x2'] = '${line.endX}'
        ..attributes['y2'] = '${line.endY}'
        ..attributes['stroke-width'] = '${line.thickness}'
        ..attributes['stroke'] = 'rgba(${line.r}, ${line.g}, ${line.b}, ${line.a/255.0})';
    } else {
      svg.LineElement svgLine = new svg.LineElement()
        ..attributes['id'] = '$id'
        ..attributes['x1'] = '${line.startX}'
        ..attributes['y1'] = '${line.startY}'
        ..attributes['x2'] = '${line.endX}'
        ..attributes['y2'] = '${line.endY}'
        ..attributes['stroke-width'] = '${line.thickness}'
        ..attributes['stroke'] = 'rgba(${line.r}, ${line.g}, ${line.b}, ${line.a/255.0})';
      idToElementMap[id] = svgLine;
      _svgContainer.append(svgLine);
    }
  });

  infra.bezierCurves.forEach((id, curve) {
    idsToRemove.remove(id);
    if (idToElementMap.containsKey(id)) {
      idToElementMap[id]
        ..attributes['d'] = 'M${curve.x1} ${curve.y1} C${curve.cx1} ${curve.cy1}, ${curve.cx2} ${curve.cy2}, ${curve.x2} ${curve.y2}'
        ..attributes['stroke-width'] = '${curve.thickness}'
        ..attributes['stroke'] = 'rgba(${curve.r}, ${curve.g}, ${curve.b}, ${curve.a/255.0})'
        ..attributes['fill'] = 'none';
    } else {
      svg.PathElement svgPath = new svg.PathElement()
        ..attributes['id'] = '$id'
        ..attributes['d'] = 'M${curve.x1} ${curve.y1} C${curve.cx1} ${curve.cy1}, ${curve.cx2} ${curve.cy2}, ${curve.x2} ${curve.y2}'
        ..attributes['stroke-width'] = '${curve.thickness}'
        ..attributes['stroke'] = 'rgba(${curve.r}, ${curve.g}, ${curve.b}, ${curve.a/255.0})'
        ..attributes['fill'] = 'none';;
      idToElementMap[id] = svgPath;
      _svgContainer.append(svgPath);
    }
  });

  for (int id in idsToRemove) {
    var element = idToElementMap.remove(id);
    _svgContainer.nodes.remove(element);
  }
}
