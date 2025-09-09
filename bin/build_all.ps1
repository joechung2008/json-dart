Write-Host "Building all executables..."
if (!(Test-Path out)) { mkdir out | Out-Null }
dart compile exe -o out/console_app.exe packages/console_app/bin/console_app.dart
dart compile exe -o out/server.exe packages/server_app/bin/server.dart
Write-Host "Build complete."
