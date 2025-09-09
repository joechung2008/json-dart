import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  final port = '8000';
  final host = 'http://localhost:$port';
  late Process p;

  setUp(() async {
    final currentDir = Directory.current.path;

    // Determine the working directory for the server process:
    // - If already in 'server_app' directory, use current directory (null)
    // - Otherwise, use relative path to server_app from workspace root
    final workingDir = path.basename(currentDir) == 'server_app'
        ? null
        : path.join('packages', 'server_app');

    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      workingDirectory: workingDir,
      environment: {'PORT': port},
    );

    // Wait for server to start and print to stdout.
    await p.stdout.first;

    // Give the server a moment to be fully ready
    await Future.delayed(Duration(milliseconds: 500));
  });

  tearDown(() => p.kill());

  group('JSON Parser API', () {
    test('Parse null', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = 'null';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), isNull);
    });

    test('Parse true', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = 'true';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), isTrue);
    });

    test('Parse false', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = 'false';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), isFalse);
    });

    test('Parse zero', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = '0';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), equals(0));
    });

    test('Parse empty array', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = '[]';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), equals([]));
    });

    test('Parse empty object', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = '{}';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('application/json'));
      expect(jsonDecode(response.body), equals({}));
    });

    test('Invalid content type', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'application/json';
      request.body = '{"key": "value"}';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 415);
      expect(response.headers['content-type'], contains('application/json'));
      final error = jsonDecode(response.body);
      expect(error['code'], equals(415));
      expect(error['message'], equals('Invalid Media Type'));
    });

    test('Invalid JSON', () async {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$host/api/v1/parse'));
      request.headers['Content-Type'] = 'text/plain';
      request.body = '{"invalid": json}';
      request.headers['Content-Length'] = utf8
          .encode(request.body)
          .length
          .toString();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      expect(response.statusCode, 400);
      expect(response.headers['content-type'], contains('application/json'));
      final error = jsonDecode(response.body);
      expect(error['code'], equals(400));
      expect(error['message'], contains('FormatException'));
    });
  });
}
