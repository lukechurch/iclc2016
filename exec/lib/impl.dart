const _TRACE_DEBUG = true;

class Executive {

  final symbolTable = <String, dynamic>{};

  program(Map p) {
    for (var s in p["statements"]) {
      statement(s);
    }
  }

  statement(Map s) {
    assert(s.keys.length == 1);
    String statementKind = s.keys.first;
    var statementValue = s.values.first;

    switch (statementKind) {
      case "variableDeclaration":
        variableDeclaration(statementValue);
        break;
      default:
        throw "unknown statement kind: $s";
    }


  }

  dynamic variableDeclaration(Map d) {
    String variableName = d["identifier"]["variable"];
    if (variableName == null) throw "No identifer name in assignment: $d";

    var v = value(d["value"]);
    symbolTable[variableName] = v;

    _trace("$v -> $variableName");
    return value;
  }

  dynamic call(Map c) {
    _trace("calling: $c");
    return true;
  }

  dynamic value(Map v) {
    assert(v.keys.length == 1);
    String key = v.keys.first;

    switch (key) {
      case "int":
      case "float":
      case "boolean":
      case "string":
        return v.values.first;
      case "variable":
        String variableName = v.values.first;
        return symbolTable[variableName];
      default:
        throw "Unknown value kind: $v";
    }
  }
}

_trace(String s) {
  if (_TRACE_DEBUG) print(s);
}
