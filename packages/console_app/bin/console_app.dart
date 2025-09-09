import 'dart:io';
import 'package:shared_lib/shared_lib.dart';

void main(List<String> arguments) {
  try {
    // Read all input from stdin
    var input = '';
    String? line;
    while ((line = stdin.readLineSync()) != null) {
      input += '$line\n';
    }
    // Remove the trailing newline if present
    if (input.endsWith('\n')) {
      input = input.substring(0, input.length - 1);
    }

    // Parse the input
    final result = parse(input);

    // Pretty print the parse tree
    print(result.token.prettyPrint());
  } catch (e) {
    // Print the error message
    print('Error: $e');
  }
}
