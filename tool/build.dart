import 'dart:io';

/// Workspace build tool.
///
/// Creates `out/` (recursively) and compiles the workspace executables into
/// `out/console_app`, `out/shelf`, and `out/dart_frog`.
///
/// This replaces shell-based scripts so the build is cross-platform.
Future<int> main() async {
  final out = Directory('out');
  if (!out.existsSync()) {
    stdout.writeln('Creating out/ directory...');
    out.createSync(recursive: true);
  }

  final targets = <Map<String, String>>[
    {
      'name': 'console_app',
      'path': 'packages/console_app/bin/console_app.dart',
    },
    {'name': 'shelf', 'path': 'packages/shelf_app/bin/server.dart'},
    {'name': 'dart_frog', 'path': 'packages/dart_frog_app/bin/server.dart'},
  ];

  for (final t in targets) {
    final name = t['name']!;
    final path = t['path']!;
    stdout.writeln('\nCompiling $name from $path...');

    // On Windows the executable should end with .exe. Use Platform to
    // determine the correct output filename.
    final exeSuffix = Platform.isWindows ? '.exe' : '';
    final outputPath = 'out/$name$exeSuffix';

    final result = await Process.run('dart', [
      'compile',
      'exe',
      '-o',
      outputPath,
      path,
    ], runInShell: true);

    if (result.stdout != null && result.stdout.toString().trim().isNotEmpty) {
      stdout.write(result.stdout);
    }
    if (result.stderr != null && result.stderr.toString().trim().isNotEmpty) {
      stderr.write(result.stderr);
    }

    if (result.exitCode != 0) {
      stderr.writeln('Failed to compile $name (exit ${result.exitCode}).');
      return result.exitCode;
    }
  }

  stdout.writeln('\nBuild finished successfully.');
  return 0;
}
