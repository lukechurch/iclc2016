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

  program(Map p) async {
    _trace("Starting execution");
    _trace("$symbolTable");

    for (var s in p["statements"]) {
      await statement(s);
    }
  }

  statement(Map s) async {
    assert(s.keys.length == 1);
    String statementKind = s.keys.first;
    var statementValue = s.values.first;

    switch (statementKind) {
      case "variableDeclaration":
        await variableDeclaration(statementValue);
        break;
      case "variableAssignment":
        await variableAssignment(statementValue);
        break;
      case "call":
        await expression(s);
        break;
      default:
        throw "unknown statement kind: $s";
    }
  }

  dynamic variableDeclaration(Map d) async {
    String variableName = d["identifier"]["variable"];
    if (variableName == null) throw "No identifer name in assignment: $d";

    var v = await expression(d["value"]);
    symbolTable[variableName] = v;

    _trace("$v -> $variableName");
    return v;
  }

  dynamic variableAssignment(Map a) async {
    String variableName = a["identifier"]["variable"];
    if (variableName == null) throw "No identifer name in assignment: $a";

    var v = await expression(a["value"]);
    symbolTable[variableName] = v;

    _trace("$v -> $variableName");
    return v;
  }

  dynamic call(Map c) async {
    _trace("calling: $c");

    String functionName = c["receiver"]["variable"];
    List args = c["args"];

    List evaledArgs = [];

    // Eval each of the args
    for (var arg in args) {
      evaledArgs.add(await expression(arg));
    }

    _trace("About to eval: $functionName $evaledArgs");

    // Patch this up into an RPC call if it's not an intrinsic
    if (!functionTable.containsKey(functionName))  {
      var rpcProxy = functionTable["intrinsics.rpc_proxy"];
      return rpcProxy(functionName, evaledArgs);
    }

    return await _callWithArgs(functionName, evaledArgs);
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

  dynamic expression(Map e) async {
    // Could be a variable, a call, or a value
    assert(e.keys.length == 1);
    String key = e.keys.first;

    switch (key) {
      case "int":
      case "float":
      case "boolean":
      case "string":
        return e.values.first;
      case "variable":
        return variableValue(e);
      case "call":
        return await call(e.values.first);
      default:
        throw "Unknwon value kind $e";
      }
  }

  dynamic variableValue(Map v) {
    String variableName = v.values.first;
    return symbolTable[variableName];
  }
}

_trace(String s) {
  if (_TRACE_DEBUG) print(s);
}
