import 'package:flutter_test/flutter_test.dart';
import 'package:i_connect/core/snippet_interpolator.dart';
import 'package:i_connect/data/repositories.dart';

void main() {
  test('renders placeholder values into shell text', () {
    const snippet = Snippet(
      id: 'snippet-1',
      title: 'Restart service',
      shellText: 'sudo systemctl restart {{service}} --user {{user}}',
      placeholders: ['service', 'user'],
    );

    final rendered = SnippetInterpolator.render(
      snippet,
      const {
        'service': 'nginx',
        'user': 'deploy',
      },
    );

    expect(rendered, 'sudo systemctl restart nginx --user deploy');
  });
}
