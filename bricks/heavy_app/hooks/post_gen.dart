import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;

  final recasedPackageName = ReCase(context.vars['project_name']).snakeCase;
  final path = '${Directory.current.path}/$recasedPackageName';
  final directory = Directory(path);

  // Run fvm use stable
  await _runFvmUseStable(logger, directory);
  // Run pre-commit install
  await _runPreCommitInstall(logger, directory);
  // Run pre-commit install --hook-type commit-msg
  await _runPreCommitInstallHooks(logger, directory);
  // Run flutter pub run rename -b bundle_id
  await _runGenerateAppUI(context, directory);
  // Run flutter pub get
  await _runMelosBootstrap(logger, directory);
  // Run dart fix
  await _runDartFixApply(logger, directory);
  // Run flutter pub run build_runner build --delete-conflicting-outputs
  await _runBuildRunner(logger, directory);
  // Run flutter pub run flutter_native_splash:create
  await _runFlutterCreateSplash(logger, directory);
  // Run flutter pub run rename -b bundle_id
  await _runRename(context, directory);

  _logSummary(logger);
}

Future<void> _runDartFixApply(Logger logger, Directory directory) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'dart fix --apply',
    executable: 'dart',
    arguments: ['fix', '--apply'],
  );
}

Future<void> _runMelosBootstrap(Logger logger, Directory directory) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'melos bootstrap',
    executable: 'melos',
    arguments: ['bootstrap'],
    errorText: 'Make sure you have melos installed.',
  );
}

Future<void> _runGenerateAppUI(HookContext context, Directory directory) async {
  final logger = context.logger;
  final projectName = context.vars['project_name'];
  final packagesPath = '${directory.path}/packages';
  final newDirectory = Directory(packagesPath);

  final progress = logger.progress('Generating app_ui');

  final generator = await MasonGenerator.fromBrick(
    Brick.version(name: 'app_ui', version: '0.0.4'),
  );

  await generator.generate(
    DirectoryGeneratorTarget(newDirectory),
    fileConflictResolution: FileConflictResolution.overwrite,
    logger: logger,
    vars: {'project_name': projectName},
  );
  progress.complete();
}

Future<void> _runRename(HookContext context, Directory directory) async {
  final logger = context.logger;
  final bundleId = context.vars['org_name'];

  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'flutter pub run rename --bundleId $bundleId',
    executable: 'flutter',
    arguments: ['pub', 'run', 'rename', '--bundleId', bundleId],
  );
}

Future<void> _runBuildRunner(
  Logger logger,
  Directory directory,
) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'flutter pub run build_runner build '
        '--delete-conflicting-outputs',
    executable: 'flutter',
    arguments: [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
  );
}

Future<void> _runFlutterCreateSplash(
  Logger logger,
  Directory directory,
) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'flutter pub run flutter_native_splash:create',
    executable: 'flutter',
    arguments: ['pub', 'run', 'flutter_native_splash:create'],
  );
}

Future<void> _runPreCommitInstallHooks(
  Logger logger,
  Directory directory,
) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'pre-commit install --hook-type commit-msg',
    executable: 'pre-commit',
    arguments: ['install', '--hook-type', 'commit-msg'],
    errorText: 'Make sure you have pre-commit installed.',
  );
}

Future<void> _runPreCommitInstall(Logger logger, Directory directory) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'pre-commit install',
    executable: 'pre-commit',
    arguments: ['install'],
    errorText: 'Make sure you have pre-commit installed.',
  );
}

Future<void> _runFvmUseStable(Logger logger, Directory directory) async {
  await _runCommand(
    logger: logger,
    directory: directory,
    runningCommand: 'fvm use stable',
    executable: 'fvm',
    arguments: ['use', 'stable'],
    errorText: 'Make sure you have fvm installed.',
  );
}

Future<void> _runCommand({
  required Logger logger,
  required Directory directory,
  required String runningCommand,
  required String executable,
  required List<String> arguments,
  String? errorText,
}) async {
  final progress = logger.progress(
    'Running "$runningCommand" in ${directory.path}',
  );

  try {
    await Process.run(
      executable,
      arguments,
      workingDirectory: directory.path,
      runInShell: true,
    );
    progress.complete();
  } catch (e) {
    progress.fail(errorText);
    throw Exception("Unknown Exception is Occur: $e");
  }
}

void _logSummary(Logger logger) {
  logger
    ..info('\n')
    ..created('Created a Heavy application!')
    ..info('\n');
}

/// Extension on the Logger class for custom styled logging.
extension LoggerX on Logger {
  /// Log a message in the "created" style of the CLI.
  void created(String message) {
    info(lightCyan.wrap(styleBold.wrap(message)));
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
