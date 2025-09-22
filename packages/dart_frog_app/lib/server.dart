import 'dart:convert';
import 'dart:io';

import 'package:shared_lib/shared_lib.dart';

/// Start a minimal HttpServer that exposes the same `/api/v1/parse` endpoint
/// used by the Dart Frog routes. This avoids requiring generated Dart Frog
/// code to be present in source control while keeping tests runnable.
Future<HttpServer> startServer({InternetAddress? address, int port = 0}) async {
  address ??= InternetAddress.loopbackIPv4;
  final server = await HttpServer.bind(address, port);

  server.listen((HttpRequest request) async {
    try {
      final path = request.uri.path;
      if (request.method != 'POST' || path != '/api/v1/parse') {
        request.response
          ..statusCode = HttpStatus.notFound
          ..close();
        return;
      }

      final contentType = request.headers.contentType?.mimeType;
      if (contentType == null || !contentType.contains('text/plain')) {
        request.response
          ..statusCode = 415
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'code': 415, 'message': 'Invalid Media Type'}))
          ..close();
        return;
      }

      final body = await utf8.decoder.bind(request).join();

      try {
        final result = parse(body);
        final json = result.token.toJson();
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(json))
          ..close();
      } catch (e) {
        request.response
          ..statusCode = 400
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'code': 400, 'message': e.toString()}))
          ..close();
      }
    } catch (_) {
      // On uncaught errors, close the request.
      try {
        request.response
          ..statusCode = 500
          ..close();
      } catch (_) {}
    }
  });

  return server;
}
