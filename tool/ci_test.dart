import 'dart:io';

Future<int> runCommand(List<String> cmd, {String? workingDirectory}) async {
  final process = await Process.start(
    cmd.first,
    cmd.sublist(1),
    workingDirectory: workingDirectory,
    runInShell: true,
  );
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  return await process.exitCode;
}

Future<void> main() async {
  // Run melos exec to run tests with coverage in each package (serial)
  print('Running package tests with coverage...');
  var exitCode = await runCommand([
    'melos',
    'exec',
    '--concurrency=1',
    '--',
    'dart',
    'test',
    '-r',
    'expanded',
    '--chain-stack-traces',
    '--coverage=coverage',
  ]);
  if (exitCode != 0) {
    exit(exitCode);
  }

  // Activate coverage tool
  print('Activating coverage tool...');
  exitCode = await runCommand([
    'dart',
    'pub',
    'global',
    'activate',
    'coverage',
  ]);
  if (exitCode != 0) exit(exitCode);

  // Find coverage directories under packages
  print('Finding coverage directories...');
  final covDirs = <String>[];
  for (final packageDir in Directory('packages').listSync()) {
    if (packageDir is Directory) {
      final cov = Directory('${packageDir.path}/coverage');
      if (await cov.exists()) {
        covDirs.add(cov.path);
      }
    }
  }

  if (covDirs.isEmpty) {
    stderr.writeln(
      'No coverage directories found under packages/. Did tests run with --coverage?',
    );
    exit(1);
  }

  // Ensure output dir
  Directory('coverage').createSync(recursive: true);

  // Run format_coverage. Pass each coverage directory as its own --in arg.
  print('Formatting coverage into coverage/lcov.info...');
  final args = [
    'pub',
    'global',
    'run',
    'coverage:format_coverage',
    '--packages=.dart_tool/package_config.json',
    '--report-on=packages',
    '--out=coverage/lcov.info',
  ];

  // Append an --in=... argument for each coverage dir
  for (final d in covDirs) {
    args.add('--in=$d');
  }

  exitCode = await runCommand(['dart', ...args]);
  if (exitCode != 0) exit(exitCode);

  print('Combined coverage written to coverage/lcov.info');
}
