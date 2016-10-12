library code_snippet;

import 'dart:async';
import 'dart:html';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/html.dart';

import 'layout_utils.dart' as layout;
import 'resize_utils.dart' as resize;
import 'utils.dart' as utils;

class CodeSnippet {
  int id;
  String setupCode;
  String bodyCode;
  Map time;
  Timer bodyTimer;
  CodeSnippetUI codeSnippetUI;
  json_rpc.Client client;

  utils.RemoveCodeSnippetCallback removeCallback =
      (CodeSnippet codeSnippet) => print('Warning! Remove callback not initialized.');

  CodeSnippet() {
    codeSnippetUI = new CodeSnippetUI(this);
    setupCode = "";
    bodyCode = "";
    updateTimer();
    setupRPCClient();
  }

  DivElement get divElement => codeSnippetUI.codeSnippetDiv;

  remove() {
    print ("Removing code");
    removeCallback(this);
    if (bodyTimer != null && bodyTimer.isActive) bodyTimer.cancel();
    client.sendRequest('dispose', [id]);
  }

  runSetupCode() {
    print ("About to send setup code");
    client.sendRequest('runSetupCode', [setupCode]).then((Map json) {
      id = json['result'];
      print ("Setup complete");
    });
  }

  runBodyCode() {
    if (id != null) {
      print ("About to run body code");
      client.sendRequest('runBodyCode', [id, bodyCode]).then((Map json) {
        notifyCodeExecuted();
        print ("Body code executed");
      });
    }
  }

  setupRPCClient() {
    var socket = new HtmlWebSocketChannel.connect(utils.SERVER_URL);
    client = new json_rpc.Client(socket)
      ..listen();
  }

  updateSetupCode() {
    StringBuffer code = new StringBuffer();
    (divElement.querySelector('.setup-code .code') as DivElement).nodes.forEach((node) {
      if (node is Element) {
        code.writeln(node.text);
      } else {
        code.writeln(node);
      }
    });
    setupCode = code.toString();
  }

  updateBodyCode() {
    print('updating body code');
    StringBuffer code = new StringBuffer();
    (divElement.querySelector('.timed-code .code') as DivElement).nodes.forEach((node) {
      if (node is Element) {
        code.writeln(node.text);
      } else {
        code.writeln(node);
      }
    });
    bodyCode = code.toString();
  }

  updateTimer() {
    time = utils.getTimeForCodeAreaFromCodeSnippet(divElement);
    Duration duration = new Duration(
      days: time['days'],
      hours: time['hours'],
      minutes: time['minutes'],
      seconds: time['seconds'],
      milliseconds: time['milliseconds']);
    if (bodyTimer != null && bodyTimer.isActive) bodyTimer.cancel();
    bodyTimer = new Timer.periodic(duration, (Timer t) => runBodyCode());
  }


  notifyCodeExecuted() {
    divElement.classes.add('notification-code-executed');
    new Timer(new Duration(milliseconds: 500), () => divElement.classes.remove('notification-code-executed'));
  }
}

class CodeSnippetUI {
  CodeSnippet codeSnippet;
  DivElement codeSnippetDiv;

  CodeSnippetUI(this.codeSnippet) {
    codeSnippetDiv = createNewSnippet();
  }

  DivElement createNewSnippet({String id, bool withResizeControls: true}) {
    DivElement snippet = new DivElement()
      ..classes.add('code-snippet-container')
      ..id = id
      ..style.width = "600px"
      ..style.height = "400px";
    addMoveControl(snippet);
    addResizeControls(snippet);
    addRemoveButton(snippet);
    addContents(snippet);
    return snippet;
  }


  addResizeControls(DivElement panel) {
    DivElement resizeControls = new DivElement()..classes.add('resize-controls');
    panel.append(resizeControls);

    // Make sure that the element's position depends only on left and top.
    // Makes computation easier later.
    panel.style
      ..left = '${panel.offset.left}px'
      ..top = '${panel.offset.top}px'
      ..bottom = null
      ..right = null;

    resizeControls.append(resize.makeTopLeftResizerForElement(panel));
    resizeControls.append(resize.makeTopRightResizerForElement(panel));
    resizeControls.append(resize.makeBottomLeftResizerForElement(panel));
    resizeControls.append(resize.makeBottomRightResizerForElement(panel));
  }

  addMoveControl(DivElement panel) {
    DivElement moveControl = new DivElement()..classes.add('move-control');
    panel.nodes.insert(0, moveControl);
    moveControl.onMouseDown.listen((MouseEvent event) {
      layout.setOnTop(panel, layout.zOrderedElements);
      event.stopPropagation();
      event.preventDefault();
      querySelector('body').style.userSelect = 'none';

      int mouseMovementX = 0, mouseMovementY = 0; // For tracking the mouse movement
      int mouseLastPositionX = event.page.x, mouseLastPositionY = event.page.y; // For tracking the mouse movement
      StreamSubscription mouseMove = document.onMouseMove.listen((MouseEvent event) {
        event.stopPropagation();
        event.preventDefault();
        mouseMovementX = event.client.x - mouseLastPositionX; // For tracking the mouse movement
        mouseMovementY = event.client.y - mouseLastPositionY; // For tracking the mouse movement
        mouseLastPositionX = event.client.x; // For tracking the mouse movement
        mouseLastPositionY = event.client.y; // For tracking the mouse movement
        int newLeft = panel.offset.left + mouseMovementX;
        int newTop = panel.offset.top + mouseMovementY;
        panel.style.left = '${newLeft}px';
        panel.style.top = '${newTop}px';
      });

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  }

  addRemoveButton(DivElement panel) {
    DivElement removeButton = new Element.html(
      """<div class="remove-button">
        <svg width="11" height="11" viewBox="0 0 45 45" xmlns="http://www.w3.org/2000/svg">
          <g transform = "rotate(45, 22.5, 22.5)">
            <rect x="15" y="0" width="15" height="45" rx="5" ry="5"/>
            <rect x="0" y="15" width="45" height="15" rx="5" ry="5"/>
          </g>
        </svg>
      </div>""",
      validator: new NodeValidatorBuilder()
        ..allowHtml5()
        ..allowInlineStyles()
        ..allowSvg());
    panel.nodes.add(removeButton);
    removeButton.onClick.listen((MouseEvent event) {
      codeSnippet.remove();
      panel.remove();
    });
  }

  addContents(DivElement panel) {
    DivElement contents = new DivElement();
    contents.classes.add('code-container');
    panel.append(contents);

    DivElement setupCodeArea = new DivElement();
    setupCodeArea.classes
      ..add('code-area')
      ..add('setup-code');
    setupSetupCodeArea(setupCodeArea);
    contents.append(setupCodeArea);

    DivElement separator = new DivElement();
    separator.classes
      ..add('separator')
      ..add('vertical');
    separator.append(new DivElement()..classes.add('line'));
    contents.append(separator);

    DivElement timedCodeArea = new DivElement();
    timedCodeArea.classes
      ..add('code-area')
      ..add('timed-code');
    setupTimedCodeArea(timedCodeArea);
    contents.append(timedCodeArea);

    // Add separator listener
    addVerticalSeparatorListener(panel);
  }

  addVerticalSeparatorListener(DivElement panel) {
    DivElement setupCodeArea = panel.querySelector('.setup-code');
    makePositionsOnlyAsLeftAndTop(setupCodeArea);
    DivElement timedCodeArea = panel.querySelector('.timed-code');
    makePositionsOnlyAsLeftAndTop(timedCodeArea);
    DivElement separator = panel.querySelector('.separator');
    makePositionsOnlyAsLeftAndTop(separator);

    separator.onMouseDown.listen((MouseEvent downEvent) {
      downEvent.stopPropagation();
      downEvent.preventDefault();

      querySelector('body').style.userSelect = 'none';
      int mouseMovementX = 0;
      int mouseLastPositionX = downEvent.page.x;
      StreamSubscription mouseMove = document.onMouseMove.listen((MouseEvent moveEvent) {
        moveEvent.stopPropagation();
        moveEvent.preventDefault();
        mouseMovementX = moveEvent.client.x - mouseLastPositionX; // For tracking the mouse movement
        mouseLastPositionX = moveEvent.client.x; // For tracking the mouse movement
        int newSetupCodeAreaWidth = setupCodeArea.offset.width + mouseMovementX;
        int newTimedCodeAreaWidth = timedCodeArea.offset.width - mouseMovementX;
        setupCodeArea.style.width = '${newSetupCodeAreaWidth}px';
        timedCodeArea.style.width = '${newTimedCodeAreaWidth}px';
      });

      StreamSubscription mouseUp;
      mouseUp = document.onMouseUp.listen((MouseEvent event) {
        mouseMove.cancel();
        mouseUp.cancel();
        querySelector('body').style.userSelect = 'text';
      });
    });
  }

  makePositionsOnlyAsLeftAndTop(Element e) {
    e.style.left = '${e.offset.left}px';
    e.style.top = '${e.offset.top}px';
    e.style.width = '${e.offset.width}px';
    e.style.bottom = null;
    e.style.right = null;
    e.style.flex = null;
  }

  setupSetupCodeArea(DivElement setupCodeArea) {
    // Add the header
    DivElement setupHeader = new DivElement()..classes.add('setup-header');
    setupCodeArea.append(setupHeader);

    DivElement refreshButton = new DivElement()
      ..classes.add('refresh-button')
      ..appendHtml("""
          <svg fill="#000000" height="20" viewBox="0 0 24 24" width="20" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 0h24v24H0z" fill="none"/>
            <path d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z"/>
          </svg>
          """, validator: new NodeValidatorBuilder()..allowSvg())
      ..append(new SpanElement()
          ..text = 'Update setup'
          ..style.lineHeight = '20px'
          ..style.verticalAlign = 'top')
      ..onClick.listen((MouseEvent event) => codeSnippet.runSetupCode());
    setupHeader.append(refreshButton);

    // Add the code area
    setupCodeArea.append(new DivElement()
      ..classes.add('code')
      ..attributes["contentEditable"] = "true"
      ..onKeyDown.listen((KeyboardEvent event) { // on shift+SPACE update the code
        if (event.shiftKey) {
          switch (new String.fromCharCode(event.which).toLowerCase()) {
            case ' ':
              event.preventDefault();
              refreshButton.click();
              refreshButton.classes.add('activate'); // Add the activate class (which simulates a click in the UI)
              break;
          }
        }
      })
      ..onKeyUp.listen((KeyboardEvent event) { // Remove the activate class (which simulates a click in the UI)
        refreshButton.classes.remove('activate');
      })
      ..onInput.listen((Event event) => codeSnippet.updateSetupCode()));
  }

  setupTimedCodeArea(DivElement timedCodeArea) {
    // Add the header
    DivElement timerHeader = new DivElement()..classes.add('timer-header');
    timedCodeArea.append(timerHeader);

    DivElement refreshButton = new DivElement()
      ..classes.add('refresh-button')
      ..style.float = 'left'
      ..appendHtml("""
          <svg fill="#000000" height="20" viewBox="0 0 24 24" width="20" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 0h24v24H0z" fill="none"/>
            <path d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z"/>
          </svg>
          """, validator: new NodeValidatorBuilder()..allowSvg())
      ..append(new SpanElement()
          ..text = 'Patch'
          ..style.lineHeight = '20px'
          ..style.verticalAlign = 'top')
      ..onClick.listen((MouseEvent event) => codeSnippet.updateBodyCode());
    timerHeader.append(refreshButton);

    DivElement repetitionContainer = new DivElement()
      ..style.overflow = 'hidden';
    timerHeader.append(repetitionContainer);

    repetitionContainer.append(new SpanElement()
      ..text = '|'
      ..style.margin = '0 4px');

    repetitionContainer.append(new SpanElement()
      ..text = 'Repeat every');

    repetitionContainer.append(new InputElement(type: "text")
      ..classes.add('timer-input')
      ..value = '1'
      ..onChange.listen((Event event) => codeSnippet.updateTimer()));

    repetitionContainer.append(new SelectElement()
      ..append(new OptionElement(data: 'milliseconds', value: 'milliseconds', selected: false))
      ..append(new OptionElement(data: 'seconds', value: 'seconds', selected: true))
      ..append(new OptionElement(data: 'minutes', value: 'minutes', selected: false))
      ..append(new OptionElement(data: 'hours', value: 'hours', selected: false))
      ..append(new OptionElement(data: 'days', value: 'days', selected: false))
      ..onChange.listen((Event event) => codeSnippet.updateTimer()));

    // Add the code area
    timedCodeArea.append(new DivElement()
      ..classes.add('code')
      ..attributes["contentEditable"] = "true"
      ..onKeyDown.listen((KeyboardEvent event) { // on shift+SPACE patch the code
        if (event.shiftKey) {
          switch (new String.fromCharCode(event.which).toLowerCase()) {
            case ' ':
              event.preventDefault();
              refreshButton.click();
              refreshButton.classes.add('activate'); // Add the activate class (which simulates a click in the UI)
              break;
          }
        }
      })
      ..onKeyUp.listen((KeyboardEvent event) { // Remove the activate class (which simulates a click in the UI)
        refreshButton.classes.remove('activate');
      })
    /* ..onInput.listen((Event event) => codeSnippet.updateBodyCode())*/);
  }

  addCodeArea(DivElement panel) {
    DivElement codeArea = new DivElement()..classes.add('code-area');
    panel.append(codeArea);
  }
}
