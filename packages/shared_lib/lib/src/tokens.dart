enum Type {
  unknown,
  array,
  false_,
  null_,
  number,
  pair,
  object,
  string,
  true_,
  value,
}

abstract class Token {
  Type type;
  Token(this.type);
}

class ArrayToken extends Token {
  List<Token> values;
  ArrayToken(this.values) : super(Type.array);
}

class FalseToken extends Token {
  bool value;
  FalseToken(this.value) : super(Type.false_);
}

class NullToken extends Token {
  final dynamic value = null;
  NullToken() : super(Type.null_);
}

class NumberToken extends Token {
  num? value;
  NumberToken(this.value) : super(Type.number);
}

class ObjectToken extends Token {
  List<PairToken> members;
  ObjectToken(this.members) : super(Type.object);
}

class PairToken extends Token {
  StringToken? key;
  Token? value;
  PairToken(this.key, this.value) : super(Type.pair);
}

class StringToken extends Token {
  String? value;
  StringToken(this.value) : super(Type.string);
}

class TrueToken extends Token {
  bool value;
  TrueToken(this.value) : super(Type.true_);
}

typedef ValueToken = Token;

class ParseResult {
  int skip;
  Token token;
  ParseResult(this.skip, this.token);
}
