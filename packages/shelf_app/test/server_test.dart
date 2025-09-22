import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf_app/server.dart' show startServer;
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  late String host;

  setUp(() async {
    server = await startServer(address: InternetAddress.loopbackIPv4, port: 0);
    host = 'http://localhost:${server.port}';
    // Give the server a short moment to be ready.
    await Future.delayed(Duration(milliseconds: 50));
  });

  tearDown(() async {
    await server.close(force: true);
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
