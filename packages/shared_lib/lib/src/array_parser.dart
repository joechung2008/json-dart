import 'tokens.dart';
import 'value_parser.dart';

enum ArrayMode { comma, elements, end, scanning }

ParseResult parseArray(String expression) {
  var mode = ArrayMode.scanning;
  var pos = 0;
  var token = ArrayToken([]);
  while (pos < expression.length && mode != ArrayMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case ArrayMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '[') {
          pos++;
          mode = ArrayMode.elements;
        } else {
          throw FormatException("expected '[', actual '$ch'");
        }
        break;
      case ArrayMode.elements:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == ']') {
          if (token.values.isNotEmpty) {
            throw FormatException("unexpected ','");
          }
          pos++;
          mode = ArrayMode.end;
        } else {
          var slice = expression.substring(pos);
          var value = parseValue(slice, RegExp(r'[ \n\r\t\],]'));
          token.values.add(value.token);
          pos += value.skip;
          mode = ArrayMode.comma;
        }
        break;
      case ArrayMode.comma:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == ']') {
          pos++;
          mode = ArrayMode.end;
        } else if (ch == ',') {
          pos++;
          mode = ArrayMode.elements;
        } else {
          throw FormatException("expected ',', actual '$ch'");
        }
        break;
      case ArrayMode.end:
        break;
    }
  }
  if (mode != ArrayMode.end) {
    throw FormatException("incomplete expression, mode ${mode.name}");
  }
  return ParseResult(pos, token);
}
