import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Console App JSON Parsing Tests', () {
    test('parses null', () async {
      final result = await runConsoleApp('null');
      expect(result.stdout.trim(), equals('null'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses false', () async {
      final result = await runConsoleApp('false');
      expect(result.stdout.trim(), equals('false'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses true', () async {
      final result = await runConsoleApp('true');
      expect(result.stdout.trim(), equals('true'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses empty array', () async {
      final result = await runConsoleApp('[]');
      expect(result.stdout.trim(), equals('[]'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses empty object', () async {
      final result = await runConsoleApp('{}');
      expect(result.stdout.trim(), equals('{}'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses zero', () async {
      final result = await runConsoleApp('0');
      expect(result.stdout.trim(), equals('0.0'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('parses empty string', () async {
      final result = await runConsoleApp('""');
      expect(result.stdout.trim(), equals('""'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });

    test('handles invalid JSON', () async {
      final result = await runConsoleApp('invalid');
      expect(result.stdout.trim(), startsWith('Error:'));
      expect(result.stderr, isEmpty);
      expect(result.exitCode, equals(0));
    });
  });
}

Future<ProcessResult> runConsoleApp(String input) async {
  // Use relative path since working directory is console_app
  final scriptPath = 'bin/console_app.dart';

  // Start the Dart process
  final process = await Process.start('dart', [
    scriptPath,
  ], workingDirectory: Directory.current.path);

  // Write input to stdin
  process.stdin.writeln(input);
  await process.stdin.close();

  // Collect output
  final stdoutBuffer = StringBuffer();
  final stderrBuffer = StringBuffer();

  final completer = Completer<void>();

  process.stdout
      .transform(SystemEncoding().decoder)
      .listen(
        (data) {
          stdoutBuffer.write(data);
        },
        onDone: () {
          if (!completer.isCompleted) completer.complete();
        },
      );

  process.stderr.transform(SystemEncoding().decoder).listen((data) {
    stderrBuffer.write(data);
  });

  final exitCode = await process.exitCode;
  await completer.future;

  return ProcessResult(
    process.pid,
    exitCode,
    stdoutBuffer.toString(),
    stderrBuffer.toString(),
  );
}
