import 'package:shared_lib/shared_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Number Tests', () {
    test('parses an integer', () {
      final result = parse('123');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(123));
    });

    test('parses a negative integer', () {
      final result = parse('-42');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(-42));
    });

    test('parses a decimal', () {
      final result = parse('3.14');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(3.14, 0.01));
    });

    test('parses scientific notation', () {
      final result = parse('1e3');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(1000));
    });

    test('parses positive exponent', () {
      final result = parse('1e5');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(100000));
    });

    test('parses large positive exponent', () {
      final result = parse('1e10');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(10000000000));
    });

    test('parses large negative exponent', () {
      final result = parse('2e-10');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(2e-10, 1e-12));
    });

    test('parses negative exponent', () {
      final result = parse('2e-3');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(0.002, 0.001));
    });

    test('parses zero', () {
      final result = parse('0');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(0));
    });

    test('parses negative zero', () {
      final result = parse('-0');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(-0));
    });

    test('parses number with leading/trailing whitespace', () {
      final result = parse('   42  ');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(42));
    });

    test('parses small decimal', () {
      final result = parse('0.00001');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(0.00001, 1e-7));
    });

    test('parses large number', () {
      final result = parse('123456789012345');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, equals(123456789012345));
    });

    test('parses negative decimal', () {
      final result = parse('-3.14');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(-3.14, 0.01));
    });

    test('parses scientific notation with negative exponent', () {
      final result = parse('2e-2');
      expect(result.token, isA<NumberToken>());
      expect((result.token as NumberToken).value, closeTo(0.02, 0.001));
    });

    test('throws on invalid input', () {
      expect(() => parse('abc'), throwsA(isA<FormatException>()));
    });

    test('throws on incomplete exponent', () {
      expect(() => parse('1e'), throwsA(isA<FormatException>()));
    });

    test('throws on invalid character after exponent', () {
      expect(() => parse('1eA'), throwsA(isA<FormatException>()));
      expect(() => parse('2E-'), throwsA(isA<FormatException>()));
      expect(() => parse('3e+ '), throwsA(isA<FormatException>()));
      expect(() => parse('1.2e12E'), throwsA(isA<FormatException>()));
      expect(() => parse('5e10X'), throwsA(isA<FormatException>()));
    });

    test('throws on plus sign', () {
      expect(() => parse('+123'), throwsA(isA<FormatException>()));
    });

    test('throws on lone decimal', () {
      expect(() => parse('.5'), throwsA(isA<FormatException>()));
    });

    test('throws on invalid mantissa', () {
      expect(() => parse('1.-23'), throwsA(isA<FormatException>()));
      expect(() => parse('1.2.3'), throwsA(isA<FormatException>()));
    });

    test('throws on NaN', () {
      expect(() => parse('NaN'), throwsA(isA<FormatException>()));
    });

    test('throws on Infinity', () {
      expect(() => parse('Infinity'), throwsA(isA<FormatException>()));
    });
  });
}
