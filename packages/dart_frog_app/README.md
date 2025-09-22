# dart_frog_app

A Dart Frog server for the json-dart workspace that exposes a small API using `shared_lib`.

Quick start

1. Inside this package, fetch dependencies:

```bash
dart pub get
```

2. Run the app locally (from this package folder):

```bash
dart run dart_frog_cli:dart_frog dev --port 8000
```

The server will by default start on http://localhost:8000 and serve routes defined in `routes/`.

Package-level tasks

These are the local commands relevant to this package. The repository also provides workspace-level Melos scripts, documented in the repository README.

- Run this package's tests:

```bash
dart test
```

- Build a local executable for this package (example):

```bash
dart compile exe -o out/dart_frog_app packages/dart_frog_app/bin/server.dart
```
