import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dart_frog_app/server.dart' show startServer;
import 'package:test/test.dart';

void main() {
  late HttpServer activeServer;
  late String host;
  late StringBuffer outBuf;
  late StringBuffer errBuf;

  setUp(() async {
    // Start the server in-process to avoid spawning separate Dart VM processes
    // which can cause port lock contention and slowdowns in tests.
    final server = await startServer(
      address: InternetAddress.loopbackIPv4,
      port: 0,
    );

    // Capture server instance to stop it in tearDown.
    outBuf = StringBuffer();
    errBuf = StringBuffer();

    // Save the HttpServer to a zone-local var by storing in a field-like var.
    // We'll close it in tearDown by calling server.close();
    // Store via a closure capture below.
    activeServer = server;
    host = 'http://localhost:${activeServer.port}';
    // Give the server a short moment to be ready.
    await Future.delayed(Duration(milliseconds: 50));
  });

  tearDown(() async {
    try {
      await activeServer.close(force: true);
    } catch (_) {}
  });

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
      try {
        expect(jsonDecode(response.body), isNull);
      } catch (e) {
        fail(
          'Failed to decode JSON from server. Body: "${response.body}"\n--- server stdout ---\n${outBuf.toString()}\n--- server stderr ---\n${errBuf.toString()}',
        );
      }
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
      try {
        final error = jsonDecode(response.body);
        expect(error['code'], equals(415));
        expect(error['message'], equals('Invalid Media Type'));
      } catch (e) {
        fail(
          'Failed to decode JSON error from server. Body: "${response.body}"\n--- server stdout ---\n${outBuf.toString()}\n--- server stderr ---\n${errBuf.toString()}',
        );
      }
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
      try {
        final error = jsonDecode(response.body);
        expect(error['code'], equals(400));
        expect(error['message'], contains('FormatException'));
      } catch (e) {
        fail(
          'Failed to decode JSON error from server. Body: "${response.body}"\n--- server stdout ---\n${outBuf.toString()}\n--- server stderr ---\n${errBuf.toString()}',
        );
      }
    });
  });
}
