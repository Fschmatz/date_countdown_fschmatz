import 'package:url_launcher/url_launcher.dart';

import 'app_details.dart';

class UtilsFunctions {
  static void openGithubRepository() {
    launchBrowser(AppDetails.repositoryLink);
  }

  static void launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
