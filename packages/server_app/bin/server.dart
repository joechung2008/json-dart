import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_lib/shared_lib.dart';

// Configure routes.
final _router = Router()..post('/api/v1/parse', _parseHandler);

Future<Response> _parseHandler(Request request) async {
  // Check Content-Type
  final contentType = request.headers['content-type'];
  if (contentType == null || !contentType.contains('text/plain')) {
    return Response(
      415,
      body: jsonEncode({'code': 415, 'message': 'Invalid Media Type'}),
      headers: {'content-type': 'application/json'},
    );
  }

  // Read body
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

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
