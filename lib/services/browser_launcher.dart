import 'package:url_launcher/url_launcher.dart';

class BrowserLauncher {
  const BrowserLauncher();

  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
