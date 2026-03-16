import 'package:flutter_test/flutter_test.dart';
import 'package:i_connect/core/server_profile_validator.dart';
import 'package:i_connect/data/repositories.dart';

void main() {
  test('flags missing browser url for managed browser modes', () {
    final issues = ServerProfileValidator.validateDraft(
      label: 'Zero Trust',
      host: 'edge.example.com',
      username: 'engineer',
      port: 22,
      networkMode: NetworkMode.cloudflareBrowser,
      browserUrl: '',
    );

    expect(
      issues,
      contains('Managed browser modes require a browser fallback URL.'),
    );
  });

  test('accepts a valid direct profile draft', () {
    final issues = ServerProfileValidator.validateDraft(
      label: 'Bastion',
      host: 'bastion.internal',
      username: 'ops',
      port: 22,
      networkMode: NetworkMode.direct,
      browserUrl: null,
    );

    expect(issues, isEmpty);
  });
}
