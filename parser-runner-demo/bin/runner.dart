import 'package:parser_runner_demo/parser.dart';
import '../../exec/lib/impl.dart' as exec;
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
  x = x - 10;
  drawCircle(x, y, radius);
  ''';



Future main() async {
  await _stepped(trivialProgram);
  // await _stress();
}

_stepped(String src) async {
  Stopwatch sw = new Stopwatch()..start();

  print ("=================== Started: ${sw.elapsed}");
  print (src);
  print ("=================== Prog: ${sw.elapsed}");
  var parsed = await parse(src);
  print (parsed);
  print ("=================== Parsed: ${sw.elapsed}");
  var executive = new exec.Executive();
  print ("=================== Initted: ${sw.elapsed}");
  var result = await executive.program(parsed['program']);
  print ("=================== Done: ${sw.elapsed}");
}


_stress(String src) async {
  Stopwatch sw = new Stopwatch()..start();

  for (int i = 0; i < 100; i++) {
    await parse(src);
    print (sw.elapsedMilliseconds);
    sw.reset();
  }
}
