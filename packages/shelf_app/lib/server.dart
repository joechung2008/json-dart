import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_lib/shared_lib.dart';

// Configure routes.
final Router _router = Router()..post('/api/v1/parse', _parseHandler);

Future<Response> _parseHandler(Request request) async {
  final contentType = request.headers['content-type'];
  if (contentType == null || !contentType.contains('text/plain')) {
    return Response(
      415,
      body: jsonEncode({'code': 415, 'message': 'Invalid Media Type'}),
      headers: {'content-type': 'application/json'},
    );
  }

  final body = await request.readAsString();

  try {
    final result = parse(body);
    final json = result.token.toJson();
    return Response.ok(
      jsonEncode(json),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response(
      400,
      body: jsonEncode({'code': 400, 'message': e.toString()}),
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Build the shelf handler used by this app.
Handler buildHandler() {
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);
  return handler;
}

/// Start an in-process HTTP server using the app handler.
/// Returns the created [HttpServer].
Future<HttpServer> startServer({InternetAddress? address, int port = 0}) async {
  address ??= InternetAddress.loopbackIPv4;
  final handler = buildHandler();
  final server = await serve(handler, address, port);
  return server;
}
