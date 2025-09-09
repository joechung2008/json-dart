@echo off
echo Building all executables...
dart compile exe packages/console_app/bin/console_app.dart
dart compile exe packages/server_app/bin/server.dart
echo Build complete.
