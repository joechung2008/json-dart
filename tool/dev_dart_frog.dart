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

Future<void> main(List<String> args) async {
  final workingDir = 'packages/dart_frog_app';
  print('Starting Dart Frog dev server in $workingDir on port 8000...');

  final cmd = [
    'dart',
    'run',
    'dart_frog_cli:dart_frog',
    'dev',
    '--port',
    '8000',
  ];
  final exitCode = await runCommand(cmd, workingDirectory: workingDir);
  if (exitCode != 0) {
    stderr.writeln('Dart Frog dev exited with code $exitCode');
    exit(exitCode);
  }
}
