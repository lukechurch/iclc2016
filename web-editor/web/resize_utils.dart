library resize.utils;

import 'dart:async';
import 'dart:html';

import 'layout_utils.dart' as layout;

makeTopLeftResizerForElement(DivElement panel) {
  // Create resize divs, add them to the resizeControls container, and then add listeners.
  DivElement topLeft = new DivElement()
    ..classes.add('top-left')
    ..classes.add('resizer');
  topLeft.onMouseDown.listen((MouseEvent downEvent) {
    downEvent.stopPropagation();
    downEvent.preventDefault();
    querySelector('body').style.userSelect = 'none';
    layout.setOnTop(panel, layout.zOrderedElements);

    int mouseMovementX = 0, mouseMovementY = 0; // For tracking the mouse movement
    int mouseLastPositionX = downEvent.page.x, mouseLastPositionY = downEvent.page.y; // For tracking the mouse movement

    StreamSubscription mouseMove;
    mouseMove = document.onMouseMove.listen((MouseEvent moveEvent) {
      mouseMovementX = moveEvent.client.x - mouseLastPositionX; // For tracking the mouse movement
      mouseMovementY = moveEvent.client.y - mouseLastPositionY; // For tracking the mouse movement
      mouseLastPositionX = moveEvent.client.x; // For tracking the mouse movement
      mouseLastPositionY = moveEvent.client.y; // For tracking the mouse movement

      int newWidth = panel.contentEdge.width - mouseMovementX;
      int newHeight = panel.contentEdge.height - mouseMovementY;
      int newLeft = panel.offset.left + mouseMovementX;
      int newTop = panel.offset.top + mouseMovementY;

      panel.style.width = '${newWidth}px';
      panel.style.height = '${newHeight}px';
      panel.style.left = '${newLeft}px';
      panel.style.top = '${newTop}px';

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  });
  return topLeft;
}

makeTopRightResizerForElement(DivElement panel) {
  // Create resize divs, add them to the resizeControls container, and then add listeners.
  DivElement topLeft = new DivElement()
    ..classes.add('top-right')
    ..classes.add('resizer');
  topLeft.onMouseDown.listen((MouseEvent downEvent) {
    downEvent.stopPropagation();
    downEvent.preventDefault();
    querySelector('body').style.userSelect = 'none';
    layout.setOnTop(panel, layout.zOrderedElements);

    int mouseMovementX = 0, mouseMovementY = 0; // For tracking the mouse movement
    int mouseLastPositionX = downEvent.page.x, mouseLastPositionY = downEvent.page.y; // For tracking the mouse movement

    StreamSubscription mouseMove;
    mouseMove = document.onMouseMove.listen((MouseEvent moveEvent) {
      mouseMovementX = moveEvent.client.x - mouseLastPositionX; // For tracking the mouse movement
      mouseMovementY = moveEvent.client.y - mouseLastPositionY; // For tracking the mouse movement
      mouseLastPositionX = moveEvent.client.x; // For tracking the mouse movement
      mouseLastPositionY = moveEvent.client.y; // For tracking the mouse movement

      int newWidth = panel.contentEdge.width + mouseMovementX;
      int newHeight = panel.contentEdge.height - mouseMovementY;
      int newLeft = panel.offset.left; // unchanged
      int newTop = panel.offset.top + mouseMovementY;

      panel.style.width = '${newWidth}px';
      panel.style.height = '${newHeight}px';
      panel.style.left = '${newLeft}px';
      panel.style.top = '${newTop}px';

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  });
  return topLeft;
}

makeBottomLeftResizerForElement(DivElement panel) {
  // Create resize divs, add them to the resizeControls container, and then add listeners.
  DivElement topLeft = new DivElement()
    ..classes.add('bottom-left')
    ..classes.add('resizer');
  topLeft.onMouseDown.listen((MouseEvent downEvent) {
    downEvent.stopPropagation();
    downEvent.preventDefault();
    querySelector('body').style.userSelect = 'none';
    layout.setOnTop(panel, layout.zOrderedElements);

    int mouseMovementX = 0, mouseMovementY = 0; // For tracking the mouse movement
    int mouseLastPositionX = downEvent.page.x, mouseLastPositionY = downEvent.page.y; // For tracking the mouse movement

    StreamSubscription mouseMove;
    mouseMove = document.onMouseMove.listen((MouseEvent moveEvent) {
      mouseMovementX = moveEvent.client.x - mouseLastPositionX; // For tracking the mouse movement
      mouseMovementY = moveEvent.client.y - mouseLastPositionY; // For tracking the mouse movement
      mouseLastPositionX = moveEvent.client.x; // For tracking the mouse movement
      mouseLastPositionY = moveEvent.client.y; // For tracking the mouse movement

      int newWidth = panel.contentEdge.width - mouseMovementX;
      int newHeight = panel.contentEdge.height + mouseMovementY;
      int newLeft = panel.offset.left + mouseMovementX;
      int newTop = panel.offset.top; // unchanged

      panel.style.width = '${newWidth}px';
      panel.style.height = '${newHeight}px';
      panel.style.left = '${newLeft}px';
      panel.style.top = '${newTop}px';

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  });
  return topLeft;
}

makeBottomRightResizerForElement(DivElement panel) {
  // Create resize divs, add them to the resizeControls container, and then add listeners.
  DivElement topLeft = new DivElement()
    ..classes.add('bottom-right')
    ..classes.add('resizer');
  topLeft.onMouseDown.listen((MouseEvent downEvent) {
    downEvent.stopPropagation();
    downEvent.preventDefault();
    querySelector('body').style.userSelect = 'none';
    layout.setOnTop(panel, layout.zOrderedElements);

    int mouseMovementX = 0, mouseMovementY = 0; // For tracking the mouse movement
    int mouseLastPositionX = downEvent.page.x, mouseLastPositionY = downEvent.page.y; // For tracking the mouse movement

    StreamSubscription mouseMove;
    mouseMove = document.onMouseMove.listen((MouseEvent moveEvent) {
      mouseMovementX = moveEvent.client.x - mouseLastPositionX; // For tracking the mouse movement
      mouseMovementY = moveEvent.client.y - mouseLastPositionY; // For tracking the mouse movement
      mouseLastPositionX = moveEvent.client.x; // For tracking the mouse movement
      mouseLastPositionY = moveEvent.client.y; // For tracking the mouse movement

      int newWidth = panel.contentEdge.width + mouseMovementX;
      int newHeight = panel.contentEdge.height + mouseMovementY;
      int newLeft = panel.offset.left; // unchanged
      int newTop = panel.offset.top; // unchanged

      panel.style.width = '${newWidth}px';
      panel.style.height = '${newHeight}px';
      panel.style.left = '${newLeft}px';
      panel.style.top = '${newTop}px';

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  });
  return topLeft;
}
