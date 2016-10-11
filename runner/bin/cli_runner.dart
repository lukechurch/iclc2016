import '../lib/parser.dart';
import '../../exec/lib/impl.dart' as exec;
import '../../ops-intrinsics-replacer/lib/ops-intrinsincs-replacer.dart' as deops;

import 'dart:async';

final sampleProgram = '''
  var x = 100;
  var y = 50;
  var radius = 10;
  while(x > 0) {
    drawCircle(x, y, radius);
    x = x - 10;
  }''';

final trivialProgram = '''
  var x = 100;
  var y = 50;
  var radius = 10;
  drawCircle(x, y, radius);
  x = x / 2;
  drawCircle(x, y, radius + 2);
  ''';



Future main() async {
  await _steppedExec(trivialProgram);
  // await _stressExec(trivialProgram);
}

_steppedExec(String src) async {
  Stopwatch sw = new Stopwatch()..start();

  print ("=================== Started: ${sw.elapsed}");
  print (src);
  print ("=================== Prog: ${sw.elapsed}");
  var parsed = await parse(src);
  print (parsed);
  print ("=================== Parsed: ${sw.elapsed}");
  deops.processAST(parsed);
  print ("=================== De-opped: ${sw.elapsed}");
  var executive = new exec.Executive();
  print ("=================== Initted: ${sw.elapsed}");
  await executive.program(parsed['program']);
  print ("=================== Done: ${sw.elapsed}");
}


_stressExec(String src) async {
  Stopwatch sw = new Stopwatch()..start();

  for (int i = 0; i < 100; i++) {
    var parsed = await parse(src);
    deops.processAST(parsed);
    var executive = new exec.Executive();
    await executive.program(parsed['program']);
    print (sw.elapsedMilliseconds);
    sw.reset();
  }
}
