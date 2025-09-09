# json-dart

A Dart workspace containing JSON parsing tools and applications.

## License

MIT

## Resources

[json.org](https://www.json.org/json-en.html)

## Packages

This workspace contains three packages:

- **console_app**: A command-line JSON parser that reads from stdin and pretty-prints parse trees
- **server_app**: A server application using the shelf package and Docker
- **shared_lib**: A Dart library for parsing JSON with token-based representation and pretty-printing

## Prerequisites

- Dart SDK ^3.9.2
- Docker (for server_app)

## Building

### Build All Packages

```bash
# From the root directory
dart pub get
```

### Build Individual Packages

```bash
# Console app
cd packages/console_app
dart pub get

# Server app
cd packages/server_app
dart pub get

# Shared library
cd packages/shared_lib
dart pub get
```

### Build Executables

To compile the executable applications:

```cmd
# Build all executables from root (Windows batch)
./bin/build_all.bat
```

```powershell
# Build all executables from root (PowerShell)
./bin/build_all.ps1
```

```bash
# Build all executables from root (Bash)
./bin/build_all.sh
```

```
# Or build individually
dart compile exe packages/console_app/bin/console_app.dart
dart compile exe packages/server_app/bin/server.dart
```

## Formatting

Format all Dart code in the workspace:

```bash
# Format all packages
dart format .

# Or format individual packages
dart format packages/console_app
dart format packages/server_app
dart format packages/shared_lib
```

## Linting

Run static analysis on all packages:

```bash
# Analyze all packages
dart analyze .

# Or analyze individual packages
dart analyze packages/console_app
dart analyze packages/server_app
dart analyze packages/shared_lib
```

## Testing

Run tests for all packages:

```bash
# Test all packages
dart test .

# Or test individual packages
dart test packages/server_app
dart test packages/shared_lib
```

### Code Coverage

Generate code coverage data from tests:

```bash
# Generate coverage for all packages
dart test --coverage=coverage .

# Or generate coverage for individual packages
dart test --coverage=coverage packages/console_app
dart test --coverage=coverage packages/server_app
dart test --coverage=coverage packages/shared_lib
```

After running tests with coverage, format the coverage data for reporting:

```bash
# Format coverage data to LCOV format
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages

# Or for individual packages
dart run coverage:format_coverage --lcov --in=packages/console_app/coverage --out=packages/console_app/coverage/lcov.info --packages=packages/console_app/.packages
dart run coverage:format_coverage --lcov --in=packages/server_app/coverage --out=packages/server_app/coverage/lcov.info --packages=packages/server_app/.packages
dart run coverage:format_coverage --lcov --in=packages/shared_lib/coverage --out=packages/shared_lib/coverage/lcov.info --packages=packages/shared_lib/.packages
```

The coverage data will be available in LCOV format for use with coverage viewers or CI/CD systems.

## Running the CLI

The console app provides a command-line JSON parser.

### Basic Usage

Pipe JSON data to the application:

```bash
echo '{"name": "John", "age": 30}' | dart run packages/console_app
```

### With File Input

```bash
dart run packages/console_app < input.json
```

### Examples

#### Valid JSON Object

```bash
$ echo '{"name": "Alice", "items": [1, 2, {"nested": true}]}' | dart run packages/console_app
{
  "name": "Alice",
  "items": [
    1.0,
    2.0,
    {
      "nested": true
    }
  ]
}
```

#### Valid JSON Array

```bash
$ echo '[1, "hello", null, true]' | dart run packages/console_app
[
  1.0,
  "hello",
  null,
  true
]
```

#### Invalid JSON (shows error)

```bash
$ echo '{"invalid": json}' | dart run packages/console_app
Error: FormatException: expected array, false, null, number, object, string, or true, actual 'j'
```

## Testing the Server API

The server app provides a REST API for JSON parsing. You can test it using the REST Client VS Code extension.

### Prerequisites

1. Install the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for VS Code

2. Start the server:

```bash
cd packages/server_app
dart run bin/server.dart
```

### Using REST Client

1. Create `.rest` files in the `testdata/` folder at the root of the workspace

2. Write HTTP requests in the following format:

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
- **Invalid Content-Type (415)**: Returns `{"code": 415, "message": "Invalid Media Type"}`
