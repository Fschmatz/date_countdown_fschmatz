import 'dart:convert';
import 'dart:io';

import 'package:date_countdown_fschmatz/util/toast_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../service/app_parameter_service.dart';
import '../service/countdown_service.dart';
import 'utils_functions.dart';

class BackupUtils {
  Future<List<Map<String, dynamic>>> _loadAll() async {
    return CountdownService().queryAllRowsDescForBackup();
  }

  Future<void> _deleteAll() async {
    await CountdownService().deleteAll();
  }

  Future<void> _insertAll(List<dynamic> jsonData) async {
    await CountdownService().insertAllFromRestoreBackup(jsonData);
  }

  Future<List<Map<String, dynamic>>> _loadAllParameters() async {
    return AppParameterService().loadAllParameters();
  }

  Future<void> _deleteAllParameters() async {
    await AppParameterService().deleteAllParameters();
  }

  Future<void> _insertParameters(List<dynamic> jsonData) async {
    await AppParameterService().insertParametersFromRestoreBackup(jsonData);
  }

  Future<void> backupData() async {
    await AppParameterService().saveLastBackupDate();

    List<Map<String, dynamic>> list = await _loadAll();
    List<Map<String, dynamic>> listParameters = await _loadAllParameters();

    if (list.isNotEmpty) {
      Map<String, dynamic> combinedData = {
        'countdowns': list,
        'parameters': listParameters,
      };

      await _saveListAsJsonAndShare(combinedData);
    } else {
      ToastUtils.show(
        "No data found!",
      );
    }
  }

  Future<void> _saveListAsJsonAndShare(Map<String, dynamic> data) async {
    try {
      final directory = await getTemporaryDirectory();
      final newFileName = UtilsFunctions.getBackupFilename();
      final file = File('${directory.path}/$newFileName');

      await file.writeAsString(json.encode(data));

      await Share.shareXFiles([XFile(file.path)], text: 'Backup $newFileName');

      ToastUtils.show(
        "Backup completed!",
      );
    } catch (e) {
      ToastUtils.showErrorMessage(
        "Error!",
      );
    }
  }

  Future<void> restoreBackupData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final dynamic decodedJson = json.decode(jsonString);

        if (decodedJson.containsKey('countdowns')) {
          await _deleteAll();
          await _insertAll(decodedJson['countdowns']);
        }

        if (decodedJson.containsKey('parameters')) {
          await _deleteAllParameters();
          await _insertParameters(decodedJson['parameters']);
        }

        ToastUtils.show(
          "Success!",
        );
      }
    } catch (e) {
      ToastUtils.showErrorMessage(
        "Error!",
      );
    }
  }
}
