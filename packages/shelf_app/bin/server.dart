import 'dart:io';

import 'package:shelf_app/server.dart' as server_lib;

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await server_lib.startServer(address: ip, port: port);
  print('Server listening on port ${server.port}');
}
