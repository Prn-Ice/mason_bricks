import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final analysisVar = context.vars['analysis'];
  final addAnalysisOptions = (analysisVar == 'true') || (analysisVar == true);

  if (addAnalysisOptions) {
    final progress = context.logger.progress('Generating analysis options');

    final recasedPackageName = ReCase(context.vars['service_name']).snakeCase;
    final serviceDirectory = '${Directory.current.path}/$recasedPackageName';
    final directory = Directory(serviceDirectory);
    final generator = await MasonGenerator.fromBrick(
      Brick.version(name: 'annoying_analysis_options', version: '0.0.1'),
    );

    await generator.generate(
      DirectoryGeneratorTarget(directory),
      fileConflictResolution: FileConflictResolution.overwrite,
      logger: context.logger,
    );
    progress.update('Analysis options generated, adding dart_code_metrics');

    try {
      await Process.run(
        'dart',
        ['pub', 'add', 'dart_code_metrics'],
        workingDirectory: directory.path,
        runInShell: true,
      );
      progress.complete('Added annoying analysis options successfully!');
    } catch (e) {
      progress.fail();
      throw Exception("Unknown Exception is Occur: $e");
    }
  }
}

class ReCase {
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');

  final symbolSet = {' ', '.', '/', '_', '\\', '-'};

  late String originalText;
  late List<String> _words;

  ReCase(String text) {
    this.originalText = text;
    this._words = _groupIntoWords(text);
  }

  List<String> _groupIntoWords(String text) {
    StringBuffer sb = StringBuffer();
    List<String> words = [];
    bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  String get snakeCase => _getSnakeCase();

  String _getSnakeCase() {
    List<String> words = this._words.map((word) => word.toLowerCase()).toList();

    return words.join('_');
  }
}
