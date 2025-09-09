import 'package:shared_lib/shared_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Array Tests', () {
    test('parses an empty array', () {
      final result = parse('[]');
      expect(result.token, isA<ArrayToken>());
      expect((result.token as ArrayToken).values, isEmpty);
    });

    test('parses a single-element array', () {
      final result = parse('[1]');
      expect(result.token, isA<ArrayToken>());
      expect((result.token as ArrayToken).values.length, equals(1));
    });

    test('parses a multi-element array', () {
      final result = parse('[1, 2, 3]');
      expect(result.token, isA<ArrayToken>());
      expect((result.token as ArrayToken).values.length, equals(3));
    });

    test('parses array with extra whitespace', () {
      final result = parse('[  1  ,   2 , 3   ]');
      expect(result.token, isA<ArrayToken>());
      expect((result.token as ArrayToken).values.length, equals(3));
      expect(
        ((result.token as ArrayToken).values[0] as NumberToken).value,
        equals(1),
      );
      expect(
        ((result.token as ArrayToken).values[1] as NumberToken).value,
        equals(2),
      );
      expect(
        ((result.token as ArrayToken).values[2] as NumberToken).value,
        equals(3),
      );
    });

    test('parses array with leading whitespace', () {
      final result = parse('   [1,2,3]');
      expect(result.token, isA<ArrayToken>());
      expect((result.token as ArrayToken).values.length, equals(3));
      expect(
        ((result.token as ArrayToken).values[0] as NumberToken).value,
        equals(1),
      );
      expect(
        ((result.token as ArrayToken).values[1] as NumberToken).value,
        equals(2),
      );
      expect(
        ((result.token as ArrayToken).values[2] as NumberToken).value,
        equals(3),
      );
    });

    test('throws on invalid delimiter between elements', () {
      expect(() => parse('[1;2]'), throwsA(isA<FormatException>()));
      expect(() => parse('[1 2]'), throwsA(isA<FormatException>()));
    });

    test('throws on missing opening bracket', () {
      expect(() => parse('1,2,3]'), throwsA(isA<FormatException>()));
    });

    test('throws on missing closing bracket', () {
      expect(() => parse('[1,2,3'), throwsA(isA<FormatException>()));
    });

    test('throws on trailing comma', () {
      expect(() => parse('[1,2,]'), throwsA(isA<FormatException>()));
    });
  });
}
