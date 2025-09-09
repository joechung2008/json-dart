import 'tokens.dart';
import 'pair_parser.dart';

enum ObjectMode { delimiter, end, pair, scanning }

ParseResult parseObject(String expression) {
  var mode = ObjectMode.scanning;
  var pos = 0;
  var members = <PairToken>[];
  while (pos < expression.length && mode != ObjectMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case ObjectMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '{') {
          pos++;
          mode = ObjectMode.pair;
        } else {
          throw FormatException("expected '{', actual '$ch'");
        }
        break;
      case ObjectMode.pair:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '}') {
          if (members.isNotEmpty) {
            throw FormatException("unexpected ','");
          }
          pos++;
          mode = ObjectMode.end;
        } else {
          var slice = expression.substring(pos);
          var pair = parsePair(slice, RegExp(r'[ \n\r\t\},]'));
          members.add(pair.token as PairToken);
          pos += pair.skip;
          mode = ObjectMode.delimiter;
        }
        break;
      case ObjectMode.delimiter:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == ',') {
          pos++;
          mode = ObjectMode.pair;
        } else if (ch == '}') {
          pos++;
          mode = ObjectMode.end;
        } else {
          throw FormatException("expected ',' or '}', actual '$ch'");
        }
        break;
      case ObjectMode.end:
        break;
    }
  }
  if (mode != ObjectMode.end) {
    throw FormatException("incomplete expression, mode ${mode.name}");
  }
  return ParseResult(pos, ObjectToken(members));
}
