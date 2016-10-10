import 'instrinsics.dart' as intrinsics;

const _TRACE_DEBUG = true;

class Executive {

  final symbolTable = <String, dynamic>{};
  final functionTable = <String, dynamic>{};

  Executive()  {
    functionTable.addAll({
      "intrinsics.add" : intrinsics.add,
      "intrinsics.sub" : intrinsics.sub,
      "intrinsics.mul" : intrinsics.mul,
      "intrinsics.div" : intrinsics.div,
      "intrinsics.mod" : intrinsics.mod,
      "intrinsics.not" : intrinsics.not,
      "intrinsics.rpc_proxy" : intrinsics.rpc_proxy
      }
    );
  }

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

    String functionName = c["receiver"]["variable"];
    List args = c["receiver"]["args"];

    // Patch this up into an RPC call if it's not an intrinsic
    if (!functionTable.containsKey(functionName))  {
      args.insert(0, functionName);
      functionName = "intrinsics.rpc_proxy";
    }

    return _callWithArgs(functionName, args);
  }

  dynamic _callWithArgs(String name, List a) {
    if (a.length > 9) throw "Only 9 args currently supported";
    switch (a.length) {
      case 0: return functionTable[name]();
      case 1: return functionTable[name](a[0]);
      case 2: return functionTable[name](a[0], a[1]);
      case 3: return functionTable[name](a[0], a[1], a[2]);
      case 4: return functionTable[name](a[0], a[1], a[2], a[3]);
      case 5: return functionTable[name](
        a[0], a[1], a[2], a[3], a[4]);
      case 6: return functionTable[name](
        a[0], a[1], a[2], a[3], a[4], a[5]);
      case 7: return functionTable[name](
        a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
      case 8: return functionTable[name](
        a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
      case 9: return functionTable[name](
        a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
      default:
        throw "Only 9 args supported. This shouldn't have got this far";
    }
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
