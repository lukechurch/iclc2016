import 'dart:async';
import 'parser.dart' as parser;
import 'package:iclc_exec/impl.dart'as exec;
import 'package:ops_intrinsics_replacer/ops-intrinsincs-replacer.dart' as deops;

class LiveRunner {
  exec.Executive executive;

  // Run and reset the executive
  Future runSetupCode(String src) async {
    var parsed = await parser.parse(src);
    deops.processAST(parsed);
    executive = new exec.Executive();
    print ("New Executive setup");
    await executive.program(parsed['program']);
  }

  // Run without resetting the executive
  Future runBodyCode(String src) async {
    if (executive == null) {
      executive = new exec.Executive();
      print ("New Executive setup");
    }
    var parsed = await parser.parse(src);
    deops.processAST(parsed);
    await executive.program(parsed['program']);
  }
}
