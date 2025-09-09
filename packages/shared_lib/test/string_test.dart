import 'package:shared_lib/shared_lib.dart';
import 'package:test/test.dart';

void main() {
  group('String Tests', () {
    test('parses a normal string', () {
      final result = parse('"hello"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('hello'));
    });

    test('parses an empty string', () {
      final result = parse('""');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals(''));
    });

    test('parses escaped quotes', () {
      final result = parse('"he\\"llo"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('he"llo'));
    });

    test('parses escaped backslash', () {
      final result = parse('"he\\\\llo"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('he\\llo'));
    });

    test('parses Unicode escape', () {
      final result = parse('"hi\\u0041"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('hiA'));
    });

    test('parses string with whitespace', () {
      final result = parse('"  spaced  "');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('  spaced  '));
    });

    test('parses string with newline', () {
      final result = parse('"line\\nend"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('line\nend'));
    });

    test('parses string with tab', () {
      final result = parse('"tab\\tend"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('tab\tend'));
    });

    test('parses string with multiple escapes', () {
      final result = parse('"a\\nb\\tc\\\\"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('a\nb\tc\\'));
    });

    test('parses long string', () {
      final longStr = '"aaaaaaaaaa"';
      final result = parse(longStr);
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('aaaaaaaaaa'));
    });

    test('parses Unicode escape sequence', () {
      final result = parse('"A=\\u0041"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('A=A'));
    });

    test('parses surrogate pair (emoji)', () {
      final result = parse('"smile=\\uD83D\\uDE00"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('smile=😀'));
    });

    test('parses string with mixed escapes', () {
      final result = parse('"mix\\n\\t"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('mix\n\t'));
    });

    test('parses string with backspace escape', () {
      final result = parse('"a\\b"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('a\b'));
    });

    test('parses string with form feed escape', () {
      final result = parse('"a\\f"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('a\f'));
    });

    test('parses string with carriage return escape', () {
      final result = parse('"a\\r"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('a\r'));
    });

    test('parses single character string', () {
      final result = parse('"x"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('x'));
    });

    test('parses string with only escape', () {
      final result = parse('"\\n"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('\n'));
    });

    test('parses string with leading whitespace', () {
      final result = parse('   "abc"');
      expect(result.token, isA<StringToken>());
      expect((result.token as StringToken).value, equals('abc'));
    });

    test('throws on unescaped newline in string', () {
      expect(() => parse('"abc\ndef"'), throwsA(isA<FormatException>()));
    });

    test('throws on invalid Unicode escape', () {
      expect(() => parse('"bad\\uZZZZ"'), throwsA(isA<FormatException>()));
    });

    test('throws on incomplete escape', () {
      expect(() => parse('"bad\\'), throwsA(isA<FormatException>()));
    });

    test('throws on invalid escape', () {
      expect(() => parse('"bad\\xescape"'), throwsA(isA<FormatException>()));
    });

    test('throws on missing opening quote', () {
      expect(() => parse('hello"'), throwsA(isA<FormatException>()));
    });

    test('throws on missing closing quote', () {
      expect(() => parse('"hello'), throwsA(isA<FormatException>()));
    });

    test('throws on incomplete Unicode escape', () {
      expect(() => parse('"hi\\u00"'), throwsA(isA<FormatException>()));
    });
  });
}
