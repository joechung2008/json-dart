# Console JSON Parser

A command-line application that parses JSON input from standard input (stdin) and outputs a pretty-printed version of the parse tree.

## Usage

Pipe JSON data to the application:

```bash
echo '{"name": "John", "age": 30}' | dart run
```

Or provide JSON via stdin:

```bash
dart run < input.json
```

## Features

- Parses JSON from stdin
- Pretty-prints the parse tree with proper indentation
- Handles complex nested structures (objects, arrays)
- Displays clear error messages for invalid JSON

## Examples

### Valid JSON Object
```bash
$ echo '{"name": "Alice", "items": [1, 2, {"nested": true}]}' | dart run
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

### Valid JSON Array
```bash
$ echo '[1, "hello", null, true]' | dart run
[
  1.0,
  "hello",
  null,
  true
]
```

### Invalid JSON
```bash
$ echo '{"invalid": json}' | dart run
Error: FormatException: expected array, false, null, number, object, string, or true, actual 'j'
```

## Dependencies

This application uses the `shared_lib` package for JSON parsing functionality.
