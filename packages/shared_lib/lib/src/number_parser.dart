import 'tokens.dart';

enum NumberMode {
  characteristic,
  characteristicDigit,
  decimalPoint,
  end,
  exponent,
  exponentDigits,
  exponentFirstDigit,
  exponentSign,
  mantissa,
  scanning,
}

ParseResult parseNumber(String expression, [RegExp? delimiters]) {
  delimiters ??= RegExp(r'[ \n\r\t]');
  var mode = NumberMode.scanning;
  var pos = 0;
  var valueAsString = '';
  var token = NumberToken(null);
  while (pos < expression.length && mode != NumberMode.end) {
    var ch = expression[pos];
    switch (mode) {
      case NumberMode.scanning:
        if (RegExp(r'[ \n\r\t]').hasMatch(ch)) {
          pos++;
        } else if (ch == '-') {
          valueAsString = '-';
          pos++;
          mode = NumberMode.characteristic;
        } else {
          mode = NumberMode.characteristic;
        }
        break;
      case NumberMode.characteristic:
        if (ch == '0') {
          valueAsString += '0';
          pos++;
          mode = NumberMode.decimalPoint;
        } else if (RegExp(r'[1-9]').hasMatch(ch)) {
          valueAsString += ch;
          pos++;
          mode = NumberMode.characteristicDigit;
        } else {
          throw FormatException("Expected digit, actual '$ch'");
        }
        break;
      case NumberMode.characteristicDigit:
        if (RegExp(r'\d').hasMatch(ch)) {
          valueAsString += ch;
          pos++;
        } else if (delimiters.hasMatch(ch)) {
          mode = NumberMode.end;
        } else {
          mode = NumberMode.decimalPoint;
        }
        break;
      case NumberMode.decimalPoint:
        if (ch == '.') {
          valueAsString += '.';
          pos++;
          mode = NumberMode.mantissa;
        } else if (delimiters.hasMatch(ch)) {
          mode = NumberMode.end;
        } else {
          mode = NumberMode.exponent;
        }
        break;
      case NumberMode.mantissa:
        if (RegExp(r'\d').hasMatch(ch)) {
          valueAsString += ch;
          pos++;
        } else if (RegExp(r'e', caseSensitive: false).hasMatch(ch)) {
          mode = NumberMode.exponent;
        } else if (delimiters.hasMatch(ch)) {
          mode = NumberMode.end;
        } else {
          throw FormatException("unexpected character '$ch'");
        }
        break;
      case NumberMode.exponent:
        if (RegExp(r'e', caseSensitive: false).hasMatch(ch)) {
          valueAsString += 'e';
          pos++;
          mode = NumberMode.exponentSign;
        } else {
          throw FormatException("expected 'e' or 'E', actual '$ch'");
        }
        break;
      case NumberMode.exponentSign:
        if (ch == '+' || ch == '-') {
          valueAsString += ch;
          pos++;
          mode = NumberMode.exponentFirstDigit;
        } else {
          mode = NumberMode.exponentFirstDigit;
        }
        break;
      case NumberMode.exponentFirstDigit:
        if (RegExp(r'\d').hasMatch(ch)) {
          valueAsString += ch;
          pos++;
          mode = NumberMode.exponentDigits;
        } else {
          throw FormatException("expected digit, actual '$ch'");
        }
        break;
      case NumberMode.exponentDigits:
        if (RegExp(r'\d').hasMatch(ch)) {
          valueAsString += ch;
          pos++;
        } else if (delimiters.hasMatch(ch)) {
          mode = NumberMode.end;
        } else {
          throw FormatException("expected digit, actual '$ch'");
        }
        break;
      case NumberMode.end:
        break;
    }
  }
  switch (mode) {
    case NumberMode.characteristic:
    case NumberMode.exponentFirstDigit:
    case NumberMode.exponentSign:
      throw FormatException("incomplete expression, mode ${mode.name}");
    default:
      token.value = double.parse(valueAsString);
      break;
  }
  return ParseResult(pos, token);
}
