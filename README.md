# json-dart

A Dart workspace containing JSON parsing tools and applications.

## License

MIT

## Resources

[json.org](https://www.json.org/json-en.html)

## Packages

This workspace contains four packages:

- **console_app**: A command-line JSON parser that reads from stdin and pretty-prints parse trees
- **shelf_app**: A server application using the `shelf` package and Docker
- **shared_lib**: A Dart library for parsing JSON with token-based representation and pretty-printing
- **dart_frog_app**: A server application using the `dart_frog` framework that exposes the same JSON parsing API

## Prerequisites

- Dart SDK >= 3.9.2
- Docker (for `shelf_app`)

## Building

### Build Packages

```bash
# From the root directory
dart pub get
```

## Formatting

Format all Dart code in the workspace:

```bash
dart format .
```

## Linting

Run static analysis on all packages:

```bash
dart analyze .
```

## Developer workflow (Melos)

This workspace uses Melos to manage multi-package tasks. Prefer the Melos scripts below for day-to-day development and CI.

Bootstrap the workspace (install package dependencies for all packages):

```bash
# From the repo root
melos bootstrap
```

Run all package tests (serial by default to avoid port conflicts in VS Code):

```bash
melos run test
```

Run the CI test script which produces a combined LCOV report at `coverage/lcov.info`:

```bash
melos run test:ci
```

Build workspace executables (replaces `bin/build_all`):

```bash
melos run build
```

## Running the CLI

The console app provides a command-line JSON parser. Run it via Melos from the workspace root:

```bash
# Example: pipe JSON to the console app
echo '{"name": "John", "age": 30}' | melos run run:console
```

## Testing the Server API

The server apps provide a REST API for JSON parsing. You can test them using the REST Client VS Code extension.

### Prerequisites

1. Install the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for VS Code

### Shelf server (shelf_app)

Start the Shelf-based server (existing implementation):

```bash
melos run run:shelf
```

### Dart Frog server (dart_frog_app)

Start the Dart Frog dev server (development-friendly):

```bash
melos run run:dart_frog
```

### Run the console app via Melos

You can also run the console CLI from the workspace using Melos:

```bash
echo '{"name": "John"}' | melos run run:console
```

### Using REST Client

1. Create `.rest` files in the `testdata/` folder at the root of the workspace

2. Write HTTP requests in the following format (both servers expose the same endpoint):

```http
POST http://localhost:8000/api/v1/parse
Content-Type: text/plain

{"key": "value", "number": 42}
```

3. Click the "Send Request" link above the request to execute it

### Example Test Cases

#### Valid JSON Object

```http
POST http://localhost:8000/api/v1/parse
Content-Type: text/plain

{"name": "John", "age": 30, "items": [1, 2, 3]}
```

#### Valid JSON Array

```http
POST http://localhost:8000/api/v1/parse
Content-Type: text/plain

[1, "hello", null, true, {"nested": "object"}]
```

#### Invalid JSON

```http
POST http://localhost:8000/api/v1/parse
Content-Type: text/plain

{"invalid": json}
```

#### Wrong Content Type

```http
POST http://localhost:8000/api/v1/parse
Content-Type: application/json

{"key": "value"}
```

### Expected Responses

- **Success (200)**: Returns the parsed JSON as `application/json`
- **Parse Error (400)**: Returns `{"code": 400, "message": "error details"}`
- **Unsupported Media Type (415)**: Returns `{"code": 415, "message": "Unsupported Media Type"}`
