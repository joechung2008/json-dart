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
- Docker
- Melos

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
dart pub get
dart run melos bootstrap
```

Build workspace executables (replaces `bin/build_all`):

```bash
dart run melos run build
```

Run all package tests:

```bash
dart run melos exec -- "dart test -r expanded --chain-stack-traces"
```

Run the CI test script to produce a combined LCOV report at `coverage/lcov.info`:

```bash
dart run melos run test:ci
```

## Running the CLI

The console app provides a command-line JSON parser.

```bash
# Enter JSON into the console app
./out/console_app

# Example: pipe JSON to the console app
echo '{"name": "John", "age": 30}' | ./out/console_app
```

## Testing the Server API

The server apps provide a REST API for JSON parsing. You can test them using the REST Client VS Code extension.

### Prerequisites

1. Install the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for VS Code

### Shelf server (shelf_app)

Start the Shelf-based server (existing implementation):

```bash
dart run melos run run:shelf
```

### Dart Frog server (dart_frog_app)

Start the Dart Frog dev server (development-friendly):

```bash
dart run melos run run:dart_frog
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
