library layout.utils;

import 'dart:html';

List<DivElement> zOrderedElements = [];

void setOnTop(Element e, List<DivElement> zOrderedElements) {
  zOrderedElements
    ..remove(e)
    ..add(e);
  updateZValues(zOrderedElements);
}

void updateZValues(List<DivElement> zOrderedElements) {
  for (int i = 0; i < zOrderedElements.length; i++) {
    Element element  = zOrderedElements[i];
    element.style.zIndex = '$i';
  }
}
