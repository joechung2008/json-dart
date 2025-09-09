import 'package:shared_lib/shared_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Object Tests', () {
    test('parses an empty object', () {
      final result = parse('{}');
      expect(result.token, isA<ObjectToken>());
      expect((result.token as ObjectToken).members, isEmpty);
    });

    test('parses a single key-value pair', () {
      final result = parse('{"a":1}');
      expect(result.token, isA<ObjectToken>());
      expect((result.token as ObjectToken).members.length, equals(1));
    });

    test('parses multiple key-value pairs', () {
      final result = parse('{"a":1,"b":2}');
      expect(result.token, isA<ObjectToken>());
      expect((result.token as ObjectToken).members.length, equals(2));
    });

    test('parses object with extra whitespace', () {
      final result = parse('  {  "a"  :  1  ,  "b"  :  2  }  ');
      expect(result.token, isA<ObjectToken>());
      expect((result.token as ObjectToken).members.length, equals(2));
      expect(
        ((result.token as ObjectToken).members[0].key as StringToken).value,
        equals('a'),
      );
      expect(
        ((result.token as ObjectToken).members[0].value as NumberToken).value,
        equals(1),
      );
      expect(
        ((result.token as ObjectToken).members[1].key as StringToken).value,
        equals('b'),
      );
      expect(
        ((result.token as ObjectToken).members[1].value as NumberToken).value,
        equals(2),
      );
    });

    test('throws on invalid key-value pair ending', () {
      expect(() => parse('{"a":1; "b":2}'), throwsA(isA<FormatException>()));
      expect(() => parse('{"a":1. "b":2}'), throwsA(isA<FormatException>()));
    });

    test('throws on missing opening brace', () {
      expect(() => parse('"a":1}'), throwsA(isA<FormatException>()));
    });

    test('throws on missing closing brace', () {
      expect(() => parse('{"a":1'), throwsA(isA<FormatException>()));
    });

    test('throws on trailing comma', () {
      expect(() => parse('{"a":1,}'), throwsA(isA<FormatException>()));
    });
  });
}
