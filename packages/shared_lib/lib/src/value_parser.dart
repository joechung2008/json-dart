import 'tokens.dart';
import 'string_parser.dart';
import 'number_parser.dart';
import 'array_parser.dart';
import 'object_parser.dart';

enum ValueMode {
  array,
  end,
  false_,
  null_,
  number,
  object,
  string,
  scanning,
  true_,
}

ParseResult parseValue(String expression, [RegExp? delimiters]) {
  var mode = ValueMode.scanning;
  var pos = 0;
  Token? token;
  while (pos < expression.length && mode != ValueMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case ValueMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '[') {
          mode = ValueMode.array;
        } else if (ch == 'f') {
          mode = ValueMode.false_;
        } else if (ch == 'n') {
          mode = ValueMode.null_;
        } else if (RegExp(r'[-\d]').hasMatch(ch)) {
          mode = ValueMode.number;
        } else if (ch == '{') {
          mode = ValueMode.object;
        } else if (ch == '"') {
          mode = ValueMode.string;
        } else if (ch == 't') {
          mode = ValueMode.true_;
        } else if (delimiters?.hasMatch(ch) ?? false) {
          mode = ValueMode.end;
        } else {
          throw FormatException(
            "expected array, false, null, number, object, string, or true, actual '$ch'",
          );
        }
        break;
      case ValueMode.array:
        {
          var slice = expression.substring(pos);
          var array = parseArray(slice);
          token = array.token;
          pos += array.skip;
          mode = ValueMode.end;
        }
        break;
      case ValueMode.false_:
        {
          if (pos + 5 > expression.length) {
            throw FormatException("incomplete 'false'");
          }
          var slice = expression.substring(pos, pos + 5);
          if (slice == 'false') {
            token = FalseToken(false);
            pos += 5;
            mode = ValueMode.end;
          } else {
            throw FormatException("expected false, actual $slice");
          }
        }
        break;
      case ValueMode.null_:
        {
          if (pos + 4 > expression.length) {
            throw FormatException("incomplete 'null'");
          }
          var slice = expression.substring(pos, pos + 4);
          if (slice == 'null') {
            token = NullToken();
            pos += 4;
            mode = ValueMode.end;
          } else {
            throw FormatException("expected null, actual $slice");
          }
        }
        break;
      case ValueMode.number:
        {
          var slice = expression.substring(pos);
          var number = parseNumber(slice, delimiters);
          token = number.token;
          pos += number.skip;
          mode = ValueMode.end;
        }
        break;
      case ValueMode.object:
        {
          var slice = expression.substring(pos);
          var object = parseObject(slice);
          token = object.token;
          pos += object.skip;
          mode = ValueMode.end;
        }
        break;
      case ValueMode.string:
        {
          var slice = expression.substring(pos);
          var string = parseString(slice);
          token = string.token;
          pos += string.skip;
          mode = ValueMode.end;
        }
        break;
      case ValueMode.true_:
        {
          if (pos + 4 > expression.length) {
            throw FormatException("incomplete 'true'");
          }
          var slice = expression.substring(pos, pos + 4);
          if (slice == 'true') {
            token = TrueToken(true);
            pos += 4;
            mode = ValueMode.end;
          } else {
            throw FormatException("expected true, actual $slice");
          }
        }
        break;
      case ValueMode.end:
        break;
    }
  }
  if (token == null) {
    throw FormatException('value cannot be empty');
  }
  return ParseResult(pos, token);
}
