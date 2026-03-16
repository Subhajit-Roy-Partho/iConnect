import '../data/repositories.dart';

class ServerProfileValidator {
  const ServerProfileValidator._();

  static List<String> validateDraft({
    required String label,
    required String host,
    required String username,
    required int port,
    required NetworkMode networkMode,
    String? browserUrl,
  }) {
    final issues = <String>[];
    if (label.trim().isEmpty) {
      issues.add('A display name is required.');
    }
    if (host.trim().isEmpty) {
      issues.add('A host is required.');
    }
    if (username.trim().isEmpty) {
      issues.add('A username is required.');
    }
    if (port < 1 || port > 65535) {
      issues.add('Port must be between 1 and 65535.');
    }
    if ((networkMode == NetworkMode.cloudflareBrowser ||
            networkMode == NetworkMode.tailscaleConsole) &&
        (browserUrl == null || browserUrl.trim().isEmpty)) {
      issues.add('Managed browser modes require a browser fallback URL.');
    }
    return issues;
  }

  static List<String> validateProfile(ServerProfile profile) {
    return validateDraft(
      label: profile.label,
      host: profile.host,
      username: profile.username,
      port: profile.port,
      networkMode: profile.networkMode,
      browserUrl: profile.managedAccessConfig.browserUrl,
    );
  }
}
