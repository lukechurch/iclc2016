library utils;

import 'dart:html';

import 'package:iclc_config/config.dart' as config;

import 'code_snippet.dart' as code;

Uri SERVER_URL = Uri.parse('ws://localhost:${config.EXECUTION_SERVER_WS_PORT}');

typedef RemoveCodeSnippetCallback(code.CodeSnippet snippet);

getTimeForCodeAreaFromCodeSnippet(DivElement codeSnippet) {
  var timeLength = (codeSnippet.querySelector('input') as InputElement).value;
  var timeUnit = (codeSnippet.querySelector('select') as SelectElement).value;

  try {
    timeLength = num.parse(timeLength);
  } catch (e) {
    print(e);
    return "Error: input not a number.";
  }

  if (timeLength == 0) {
    return "Error: input should not be zero.";
  }

  return {
    'days': timeUnit == 'days' ? timeLength : 0,
    'hours': timeUnit == 'hours' ? timeLength : 0,
    'minutes': timeUnit == 'minutes' ? timeLength : 0,
    'seconds': timeUnit == 'seconds' ? timeLength : 0,
    'milliseconds': timeUnit == 'milliseconds' ? timeLength : 0,
  };
}
