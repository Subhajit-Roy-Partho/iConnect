import '../data/repositories.dart';

class SnippetInterpolator {
  const SnippetInterpolator._();

  static String render(
    Snippet snippet,
    Map<String, String> values,
  ) {
    var output = snippet.shellText;
    for (final placeholder in snippet.placeholders) {
      output = output.replaceAll(
        '{{$placeholder}}',
        values[placeholder] ?? '',
      );
    }
    return output;
  }
}
