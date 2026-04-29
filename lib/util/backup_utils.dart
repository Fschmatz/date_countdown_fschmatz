import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/app_parameter_service.dart';
import '../service/countdown_service.dart';

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

  Future<void> _loadStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  // Always using Android Download folder
  Future<String> _loadDirectory() async {
    bool dirDownloadExists = true;
    String directory = "/storage/emulated/0/Download/";

    dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download/";
    } else {
      directory = "/storage/emulated/0/Downloads/";
    }

    return directory;
  }

  Future<void> backupData(String fileName) async {
    await _loadStoragePermission();
    await AppParameterService().saveLastBackupDate();

    List<Map<String, dynamic>> list = await _loadAll();
    List<Map<String, dynamic>> listParameters = await _loadAllParameters();

    if (list.isNotEmpty) {
      Map<String, dynamic> combinedData = {
        'countdowns': list,
        'parameters': listParameters,
      };

      await _saveDataAsJson(combinedData, fileName);

      Fluttertoast.showToast(
        msg: "Backup completed!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "No data found!",
      );
    }
  }

  Future<void> _saveDataAsJson(Map<String, dynamic> data, String fileName) async {
    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');

      await file.writeAsString(json.encode(data));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error!",
      );
    }
  }

  Future<void> restoreBackupData(String fileName) async {
    await _loadStoragePermission();

    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');
      final jsonString = await file.readAsString();
      final dynamic decodedJson = json.decode(jsonString);

      if (decodedJson is List) {
        // Old Backup (Countdowns Only)
        await _deleteAll();
        await _insertAll(decodedJson);
      } else if (decodedJson is Map<String, dynamic>) {
        // New Backup (Countdowns + Parameters)
        if (decodedJson.containsKey('countdowns')) {
          await _deleteAll();
          await _insertAll(decodedJson['countdowns']);
        }

        if (decodedJson.containsKey('parameters')) {
          await _deleteAllParameters();
          await _insertParameters(decodedJson['parameters']);
        }
      }

      Fluttertoast.showToast(
        msg: "Success!",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error!",
      );
    }
  }
}
