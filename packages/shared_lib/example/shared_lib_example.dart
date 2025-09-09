import 'package:shared_lib/shared_lib.dart';

void main() {
  // Example JSON string to parse
  String jsonString =
      '{"name": "John", "age": 30, "isStudent": false, "courses": ["Math", "Science"]}';

  try {
    // Parse the JSON string
    var result = parse(jsonString);

    // Print the result
    print('Parsed successfully!');
    print('Token type: ${result.token.type}');
    print('Characters consumed: ${result.skip}');

    // If it's an object, print some details
    if (result.token is ObjectToken) {
      var obj = result.token as ObjectToken;
      print('Object has ${obj.members.length} members');
    }
  } catch (e) {
    print('Parsing error: $e');
  }
}
