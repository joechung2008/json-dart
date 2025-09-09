import 'tokens.dart';

extension TokenPrettyPrint on Token {
  String prettyPrint({int indent = 0}) {
    var spaces = '  ' * indent;
    switch (type) {
      case Type.array:
        var array = this as ArrayToken;
        if (array.values.isEmpty) return '[]';
        var result = '[\n';
        for (var i = 0; i < array.values.length; i++) {
          result +=
              '$spaces  ${array.values[i].prettyPrint(indent: indent + 1)}';
          if (i < array.values.length - 1) result += ',';
          result += '\n';
        }
        result += '$spaces]';
        return result;
      case Type.object:
        var obj = this as ObjectToken;
        if (obj.members.isEmpty) return '{}';
        var result = '{\n';
        for (var i = 0; i < obj.members.length; i++) {
          var pair = obj.members[i];
          var key = pair.key?.value;
          result +=
              '$spaces  "$key": ${pair.value!.prettyPrint(indent: indent + 1)}';
          if (i < obj.members.length - 1) result += ',';
          result += '\n';
        }
        result += '$spaces}';
        return result;
      case Type.string:
        var value = (this as StringToken).value;
        return '"$value"';
      case Type.number:
        return '${(this as NumberToken).value}';
      case Type.true_:
        return 'true';
      case Type.false_:
        return 'false';
      case Type.null_:
        return 'null';
      default:
        return 'unknown';
    }
  }
}

extension TokenToJson on Token {
  dynamic toJson() {
    switch (type) {
      case Type.array:
        var array = this as ArrayToken;
        return array.values.map((v) => v.toJson()).toList();
      case Type.object:
        var obj = this as ObjectToken;
        var map = <String, dynamic>{};
        for (var pair in obj.members) {
          map[pair.key!.value!] = pair.value!.toJson();
        }
        return map;
      case Type.string:
        return (this as StringToken).value;
      case Type.number:
        return (this as NumberToken).value;
      case Type.true_:
        return true;
      case Type.false_:
        return false;
      case Type.null_:
        return null;
      default:
        throw FormatException('Unknown token type');
    }
  }
}
