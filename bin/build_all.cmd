@echo off
echo Building all executables...
if not exist out mkdir out
dart compile exe -o out/console_app.exe packages/console_app/bin/console_app.dart
dart compile exe -o out/server.exe packages/server_app/bin/server.dart
echo Build complete.
