import 'tokens.dart';

enum StringMode { char, end, escapedChar, scanning, unicode }

ParseResult parseString(String expression) {
  var mode = StringMode.scanning;
  var pos = 0;
  String? value;
  while (pos < expression.length && mode != StringMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case StringMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '"') {
          value = '';
          pos++;
          mode = StringMode.char;
        } else {
          throw FormatException("expected '\"', actual '$ch'");
        }
        break;
      case StringMode.char:
        if (ch == '\\') {
          pos++;
          mode = StringMode.escapedChar;
        } else if (ch == '"') {
          pos++;
          mode = StringMode.end;
        } else if (ch != '\n' && ch != '\r') {
          value = '${value ?? ''}$ch';
          pos++;
        } else {
          throw FormatException("unexpected character '$ch'");
        }
        break;
      case StringMode.escapedChar:
        if (ch == '"' || ch == '\\' || ch == '/') {
          value = '${value ?? ''}$ch';
          pos++;
          mode = StringMode.char;
        } else if (ch == 'b') {
          value = '${value ?? ''}\b';
          pos++;
          mode = StringMode.char;
        } else if (ch == 'f') {
          value = '${value ?? ''}\f';
          pos++;
          mode = StringMode.char;
        } else if (ch == 'n') {
          value = '${value ?? ''}\n';
          pos++;
          mode = StringMode.char;
        } else if (ch == 'r') {
          value = '${value ?? ''}\r';
          pos++;
          mode = StringMode.char;
        } else if (ch == 't') {
          value = '${value ?? ''}\t';
          pos++;
          mode = StringMode.char;
        } else if (ch == 'u') {
          pos++;
          mode = StringMode.unicode;
        } else {
          throw FormatException("unexpected escape character '$ch'");
        }
        break;
      case StringMode.unicode:
        if (pos + 4 > expression.length) {
          throw FormatException(
            "incomplete Unicode code '${expression.substring(pos)}'",
          );
        }
        var slice = expression.substring(pos, pos + 4);
        try {
          var hex = int.parse(slice, radix: 16);
          value = (value ?? '') + String.fromCharCode(hex);
          pos += 4;
          mode = StringMode.char;
        } catch (e) {
          throw FormatException("unexpected Unicode code '$slice'");
        }
        break;
      case StringMode.end:
        break;
    }
  }
  if (mode != StringMode.end) {
    throw FormatException("incomplete string, mode ${mode.name}");
  }
  return ParseResult(pos, StringToken(value));
}
