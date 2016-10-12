import 'dart:html';

import 'code_snippet.dart' as code;

List<code.CodeSnippet> codeSnippets = [];

main() {
  querySelector('#add-button').onClick.listen((MouseEvent event) {
    code.CodeSnippet snippet = new code.CodeSnippet();
    querySelector('body').append(snippet.divElement);
    codeSnippets.add(snippet);
    snippet.removeCallback = removeCodeSnippet;
  });
}

removeCodeSnippet(code.CodeSnippet snippet) {
  codeSnippets.remove(snippet);
}
