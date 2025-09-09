import 'tokens.dart';
import 'string_parser.dart';
import 'value_parser.dart';

enum PairMode { colon, end, scanning, string, value }

ParseResult parsePair(String expression, [RegExp? delimiters]) {
  var mode = PairMode.scanning;
  var pos = 0;
  var token = PairToken(null, null);
  while (pos < expression.length && mode != PairMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case PairMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else {
          mode = PairMode.string;
        }
        break;
      case PairMode.string:
        {
          var slice = expression.substring(pos);
          var string = parseString(slice);
          token.key = string.token as StringToken;
          pos += string.skip;
          mode = PairMode.colon;
        }
        break;
      case PairMode.colon:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == ':') {
          pos++;
          mode = PairMode.value;
        } else {
          throw FormatException("expected ':', actual '$ch'");
        }
        break;
      case PairMode.value:
        {
          var slice = expression.substring(pos);
          var value = parseValue(slice, delimiters);
          token.value = value.token;
          pos += value.skip;
          mode = PairMode.end;
        }
        break;
      case PairMode.end:
        break;
    }
  }
  if (mode != PairMode.end) {
    throw FormatException("incomplete expression, mode ${mode.name}");
  }
  return ParseResult(pos, token);
}
