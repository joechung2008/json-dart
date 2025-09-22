import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:shared_lib/shared_lib.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final contentType = request.headers['content-type'];
  if (contentType == null || !contentType.contains('text/plain')) {
    return Response(
      statusCode: 415,
      body: jsonEncode({'code': 415, 'message': 'Invalid Media Type'}),
      headers: {'content-type': 'application/json'},
    );
  }

  final body = await request.body();

  try {
    final result = parse(body);
    final json = result.token.toJson();
    return Response(
      statusCode: 200,
      body: jsonEncode(json),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response(
      statusCode: 400,
      body: jsonEncode({'code': 400, 'message': e.toString()}),
      headers: {'content-type': 'application/json'},
    );
  }
}
