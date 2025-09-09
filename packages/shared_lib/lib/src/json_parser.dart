import 'tokens.dart';
import 'value_parser.dart';

enum JsonMode { end, scanning, value }

ParseResult parse(String expression) {
  var mode = JsonMode.scanning;
  var pos = 0;
  Token? token;
  while (pos < expression.length && mode != JsonMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case JsonMode.scanning:
        if (RegExp(r'\s').hasMatch(ch)) {
          pos++;
        } else {
          mode = JsonMode.value;
        }
        break;
      case JsonMode.value:
        var slice = expression.substring(pos);
        var value = parseValue(slice);
        token = value.token;
        pos += value.skip;
        // Skip trailing whitespace
        while (pos < expression.length &&
            RegExp(r'\s').hasMatch(expression[pos])) {
          pos++;
        }
        if (pos != expression.length) {
          throw FormatException('unexpected content after JSON value');
        }
        mode = JsonMode.end;
        break;
      case JsonMode.end:
        break;
    }
  }
  if (token == null) {
    throw FormatException('JSON value cannot be empty');
  }
  return ParseResult(pos, token);
}
