import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  try {
    await Process.run(
      'dart',
      ['pub', 'add', 'mason'],
      runInShell: true,
    );
  } catch (e) {
    throw Exception("Unknown Exception is Occur: $e");
  }
}
