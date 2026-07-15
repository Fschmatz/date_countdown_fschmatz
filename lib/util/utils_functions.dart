import 'package:url_launcher/url_launcher.dart';
import 'package:jiffy/jiffy.dart';

import 'app_details.dart';

class UtilsFunctions {
  static String getBackupFilename() {
    String name = AppDetails.backupFileName;
    String dateTimeStr = Jiffy.now().format(pattern: 'dd_MM_yyyy_HHmmss');
    return '${name}_$dateTimeStr.json';
  }

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
