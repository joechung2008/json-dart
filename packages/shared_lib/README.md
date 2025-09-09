# shared_lib

A Dart package for parsing JSON strings into structured tokens. This is a port of a TypeScript JSON parser to Dart.

## Features

- Parse JSON strings into token-based representations
- Support for all JSON data types:
  - Numbers (integers, decimals, scientific notation)
  - Strings (with escape sequences)
  - Arrays
  - Objects
  - Booleans (true/false)
  - Null values
- Handles whitespace and formatting
- Provides detailed error messages for invalid JSON

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  shared_lib:
    path: ../shared_lib
```

Or if publishing to pub.dev:

```yaml
dependencies:
  shared_lib: ^1.0.0
```

## Usage

Import the package and use the `parse` function:

```dart
import 'package:shared_lib/shared_lib.dart';

void main() {
  // Parse a JSON string
  String jsonString = '{"name": "John", "age": 30, "isStudent": false}';
  var result = parse(jsonString);

  print('Parsed successfully!');
  print('Token type: ${result.token.type}');
  print('Characters consumed: ${result.skip}');

  // Access the parsed object
  if (result.token is ObjectToken) {
    var obj = result.token as ObjectToken;
    print('Object has ${obj.members.length} members');
  }
}
```

The parser returns a `ParseResult` containing:
- `token`: The parsed token (ArrayToken, ObjectToken, etc.)
- `skip`: Number of characters consumed from the input

### Token Types

- `ArrayToken`: Represents JSON arrays
- `ObjectToken`: Represents JSON objects
- `StringToken`: Represents JSON strings
- `NumberToken`: Represents JSON numbers
- `TrueToken`: Represents `true`
- `FalseToken`: Represents `false`
- `NullToken`: Represents `null`

## Example

See the `example/shared_lib_example.dart` file for a complete example.

## Testing

Run the tests:

```bash
dart test
```

The package includes comprehensive tests covering all parsing scenarios and error conditions.

## Additional information

This package is a Dart port of a TypeScript JSON parser. It provides a token-based approach to JSON parsing, which can be useful for applications that need to process JSON structure without converting to native Dart types.

For more information about Dart package development, see the [Dart guides](https://dart.dev/guides).
