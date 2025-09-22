import 'dart:io';
import 'package:dart_frog_app/server.dart' as server_lib;

Future<void> main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await server_lib.startServer(address: ip, port: port);
  print('Dart Frog server listening on port ${server.port}');
}
