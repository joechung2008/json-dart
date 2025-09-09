import 'package:shared_lib/shared_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Boolean and Null Tests', () {
    test('parses true', () {
      final result = parse('true');
      expect(result.token.type, isNotNull);
    });

    test('parses false', () {
      final result = parse('false');
      expect(result.token.type, isNotNull);
    });

    test('parses null', () {
      final result = parse('null');
      expect(result.token.type, isNotNull);
    });

    test('throws on empty input', () {
      expect(() => parse(''), throwsA(isA<FormatException>()));
    });

    test('throws on invalid input', () {
      expect(() => parse('invalid'), throwsA(isA<FormatException>()));
    });

    test('throws on typo in \'null\'', () {
      expect(() => parse('nul'), throwsA(isA<FormatException>()));
      expect(() => parse('nall'), throwsA(isA<FormatException>()));
      expect(() => parse('nulL'), throwsA(isA<FormatException>()));
    });

    test('throws on typo in \'false\'', () {
      expect(() => parse('falze'), throwsA(isA<FormatException>()));
      expect(() => parse('fa1se'), throwsA(isA<FormatException>()));
      expect(() => parse('falsy'), throwsA(isA<FormatException>()));
    });

    test('throws on typo in \'true\'', () {
      expect(() => parse('tru'), throwsA(isA<FormatException>()));
      expect(() => parse('trua'), throwsA(isA<FormatException>()));
      expect(() => parse('ture'), throwsA(isA<FormatException>()));
      expect(() => parse('treu'), throwsA(isA<FormatException>()));
    });
  });
}
