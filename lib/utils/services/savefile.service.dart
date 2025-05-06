import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:http/http.dart' as HTTP;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';

import '../log/crashlystic_services.dart';
import '../utils.dart';

class SaveFileService {
  final _appState = new AppState();

  Future<CroppedFile?> cropImage(File image) async {
    try {
      final uiSettings = <PlatformUiSettings>[
        if (Platform.isAndroid)
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        if (Platform.isIOS)
          IOSUiSettings(
            title: 'Crop Image',
          ),
      ];

      return await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(
            ratioX: 1, ratioY: 1), // hoặc bỏ nếu không muốn cố định
        uiSettings: uiSettings,
      );
    } catch (e) {
      debugPrint('❌ Error cropping image: $e');
      return null;
    }
  }
  Future checkAvatar() async {
    final userProfile = _appState.getMoreInfoUserInfoStore();
    if (Utils.checkIsNotNull(userProfile)) {
      // final empCode = userProfile['empCode'];
      String empCode = userProfile['empCode'];
      final saveFileService = new SaveFileService();
      final fileAvatar =
          await StorageHelper.getString(AppStateConfigConstant.AVATAR_FILE) ??
              '';
      if (Utils.checkIsNotNull(fileAvatar)) {
        empCode = fileAvatar;
      }
      final isAvatarExist = await saveFileService.checkFileIsExist(empCode);
      if (!isAvatarExist) {
        final res = await saveFileService.getAvatarUserLogin();
        if (Utils.checkIsNotNull(res)) {
          if (res.contentLength > 0) {
            _appState.isCheckShowAvatarComplete = true;
            await StorageHelper.setString(
                AppStateConfigConstant.AVATAR_FILE,
                empCode +
                    '_' +
                    DateTime.now().millisecondsSinceEpoch.toString());
            final fileName = empCode + '.jpeg';
            _appState.pathFileAvatar = await getPathFile(fileName);
            await saveFileService.handleDownLoadFile(fileName, res);
          }
        } else {
          // Vui long cap nhat avatar
        }
      }
    }
  }

  Future getPathFileAvatar() async {
    final userProfile = _appState.getMoreInfoUserInfoStore();
    if (Utils.checkIsNotNull(userProfile)) {
      final empCode = userProfile['empCode'];
      return await getPathFile(empCode) + '.jpeg';
    }
  }

  Future getAvatarUserLogin() async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    final url = DMS_SERVICE_URL.GET_AVARTAR + '?username=' + userName;
    final response = await get(Uri.parse(url),
        headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
    if (response.statusCode == 200) {
      return response;
    }
    return null;
  }

  Future<HTTP.Response?> postTequestDownLoadFile(String url, var _body) async {
    try {
      final storageToken =
          await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
      var params = json.encode(_body);
      final response = await HTTP.post(Uri.parse(url),
          encoding: Encoding.getByName("UTF-8"),
          body: params,
          headers: {
            'Authorization': APP_CONFIG.KEY_JWT + '$storageToken',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200 && response.contentLength! > 0) {
        if (Utils.checkIsNotNull(response.body)) {
          if (response.body.indexOf('"status":1') > -1) {
            return null;
          }
        }
        return response;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getDownLoadFile(String url) async {
    try {
      final storageToken =
          await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
      final response = await HTTP.get(Uri.parse(url), headers: {
        'Authorization': APP_CONFIG.KEY_JWT + '$storageToken',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200 && response.contentLength! > 0) {
        if (Utils.checkIsNotNull(response.body)) {
          if (response.body.indexOf('"status":1') > -1) {
            return null;
          }
        }
        return response;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> localFile(String filename) async {
    final path = await getApplicationDocumentsDirectory();
    return File('$path/$filename');
  }

  Future<String> writeData(String filename, data) async {
    final file = await localFile(filename);
    file.writeAsBytes(data);
    return file.path;
  }

  Future<bool> checkFileIsExist(String fileName,
      {String path = 'images'}) async {
    try {
      final pathFile = await getPathFile(fileName, path: path);
      File file = File(pathFile);
      if (await file.exists()) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getPathFile(String fileName, {String path = 'images'}) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    String filePathAndName =
        documentDirectory.path + '/' + path + '/' + fileName;
    return filePathAndName;
  }

  Future handleDownLoadFilePDF(String fileName, dynamic _downloadData,
      {bool isStored = false}) async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = '';
      String filePathAndName = '';
      isStored = false;
      if (isStored) {
        final _canStorage = await checkStoragePermission();
        if (_canStorage) {
          final data = await createPathFile(
              documentDirectory, firstPath, filePathAndName, fileName, 'pdf');
          if (Utils.checkIsNotNull(data)) {
            firstPath = data.first;
            filePathAndName = data.last;
          }
        } else {
          return null;
        }
      } else {
        firstPath = documentDirectory.path + "/pdf";
        filePathAndName = documentDirectory.path + '/pdf/' + fileName;
      }
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file = new File(filePathAndName); // <-- 2
      file.writeAsBytesSync(_downloadData.bodyBytes, flush: true); //
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future createPathFile(Directory documentDirectory, String firstPath,
      String filePathAndName, String fileName, String _extension) async {
    if (Platform.isAndroid) {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        // Handle the null case gracefully
        return {firstPath, filePathAndName};
      }      List<String> paths = documentDirectory.path.split("/");
      String newPath = "";
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != 'Android') {
          newPath += '/' + folder;
        } else {
          break;
        }
      }
      firstPath = newPath + '/Download/AthenaOwl';
      filePathAndName = firstPath + '/' + fileName;
    } else if (Platform.isIOS) {
      firstPath = documentDirectory.path + '/' + _extension;
      filePathAndName =
          documentDirectory.path + '/' + _extension + '/' + fileName;
    }
    return {firstPath, filePathAndName};
  }

  Future handleDownLoadFileZip(String fileName, dynamic _downloadData,
      {bool isStored = false}) async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = '';
      String filePathAndName = '';
      // Store file trong thu muc download
      isStored = false;
      if (!isStored) {
        firstPath = documentDirectory.path + "/zip";
        filePathAndName = documentDirectory.path + '/zip/' + fileName;
      }
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file = new File(filePathAndName); // <-- 2
      file.writeAsBytesSync(_downloadData.bodyBytes, flush: true); //
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future handleDownLoadFile(String fileName, dynamic _downloadData) async {
    try {
      final documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file = new File(filePathAndName); // <-- 2
      file.writeAsBytesSync(_downloadData.bodyBytes, flush: true); //
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getFileFromUrl(url) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    try {
      final response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        if (Utils.checkIsNotNull(response.headers)) {
          return response;
        }
      }
      return null;
    } catch (exception) {
      return null;
    }
  }

  Future<dynamic> handleDownloadOpenFile(
      String folderName, String fileName, dynamic _downloadData,
      {bool isStored = false}) async {
    try {
      final _canStorage = await checkStoragePermission();

      if (_canStorage) {
        return await _readFileOpen(_downloadData, folderName, fileName);
      } else {
        return {
          'status': DownloadStatus.noPerrmission,
          'firstPath': null,
          'filePathAndName': null,
          'bodyBytes': null
        };
      }
    } catch (e) {
      return null;
    }
  }

  Future<DownloadStatus> handleDownloadCheckin(
      String folderName, String fileName, dynamic _downloadData,
      {bool isStored = false}) async {
    try {
      final _canStorage = await checkStoragePermission();

      if (_canStorage) {
        return await _readFile(_downloadData, folderName, fileName);
      } else {
        return DownloadStatus.noPerrmission;
      }
    } catch (e) {
      return DownloadStatus.callFailed;
    }
  }

  Future<DownloadStatus> downloadAndPrintFile(
      String folderName, String fileName, dynamic _downloadData,
      {String? contractId = '', String prefixShare = 'TBKK_'}) async {
    try {
      final _canStorage = await checkStoragePermission();

      if (_canStorage) {
        return await _readFile(_downloadData, folderName, fileName,
            isShareFile: true, contracId: contractId, prefixShare: prefixShare);
      } else {
        return DownloadStatus.noPerrmission;
      }
    } catch (e) {
      return DownloadStatus.callFailed;
    }
  }

  Future<String> get _localPath async {
    if (Platform.isAndroid) {
      // Yêu cầu quyền trước
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final directory = await getExternalStorageDirectory();
        return directory?.path ?? '';
      } else {
        // Nếu không có quyền, fallback về thư mục tạm
        final tempDir = await getTemporaryDirectory();
        return tempDir.path;
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }

    return '';
  }

  Future<File?> _localFile(String folderPath, String fileName) async {
    final path = await _localPath;
  
  // Fix: Remove unnecessary null check on isNotEmpty (which is a boolean)
  if (path.isNotEmpty) {
    // Get folder path, handling null return
    String? pathFromCatch = await _createFolder('$path/$folderPath', folderName: folderPath);
    
    // Check if pathFromCatch is null
    if (pathFromCatch == null) {
      return null;
    }
    
    // Create and return the file
    return File('$pathFromCatch/$fileName');
  }

  return null;
  }

  Future<dynamic> _readFileOpen(
      dynamic bodyBytes, String folderName, String fileName,
      {String contracId = '',
      bool isShareFile = false,
      String prefixShare = ''}) async {
    try {
      // fileName = fileName.replaceAll('-', '_');
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      String firstName = fileName.split('.').first;
      String formatFile = fileName.split('.').last;

      final file = await _localFile(
          folderName, firstName + '_$timestamp' + '.$formatFile');

      file?.writeAsBytesSync(bodyBytes, flush: true, mode: FileMode.write); //
      if (isShareFile) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd_MM_yyyy').format(now);
        final xFile = XFile(file?.path ?? '');

        await Share.shareXFiles([xFile],
            subject: 'Athena Owl share TBKK' + contracId + '_' + formattedDate,
            text: prefixShare + (contracId ?? '') + '_' + formattedDate);
      }

      return {
        'status': DownloadStatus.successed,
        'firstPath': file?.path,
        'filePathAndName': file?.path,
        'bodyBytes': bodyBytes
      };

      // Read the file
    } catch (e) {
      return {
        'status': DownloadStatus.saveFileFailed,
        'firstPath': null,
        'filePathAndName': null,
        'bodyBytes': null
      };
    }
  }

  Future<DownloadStatus> _readFile(
    dynamic bodyBytes, String folderName, String fileName,
    {String? contracId = '',
    bool isShareFile = false,
    String prefixShare = ''}) async {
  try {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String firstName = fileName.split('.').first;
    String formatFile = fileName.split('.').last;

    // Get the file
    final file = await _localFile(
        folderName, '${firstName}_$timestamp.$formatFile');
    
    // Check if file is null
    if (file == null) {
      return DownloadStatus.createPathFailed;
    }

    // Now file is guaranteed to be non-null
    file.writeAsBytesSync(bodyBytes, flush: true, mode: FileMode.write);
    
    if (isShareFile) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd_MM_yyyy').format(now);
      
      // Create XFile from the file path
      final xFile = XFile(file?.path ?? '');
      
      await Share.shareXFiles(
        [xFile], // Pass XFile objects, not String paths
        subject: 'Athena Owl share TBKK$contracId\_$formattedDate',
        text: '$prefixShare${contracId ?? ''}\_$formattedDate'
      );
    }
    
    return DownloadStatus.successed;
  } catch (e) {
    debugPrint('Error in _readFile: $e');
    return DownloadStatus.saveFileFailed;
  }
    }

  Future<String?> _createFolder(String pathValue,
      {String folderName = ''}) async {
    try {
      final path = Directory(pathValue);
      if (await path.exists()) {
        // Return the path if it exists instead of null
        return pathValue;
      } else {
        // Create and return the path
        await path.create(recursive: true);
        return pathValue;
      }
    } catch (e) {
      if (Platform.isAndroid) {
        Directory? appDocDirectory = await getExternalStorageDirectory();
        if(appDocDirectory == null) {
          return null;
        }
        Directory directory =
            await Directory(appDocDirectory.path + '/' + folderName)
                .create(recursive: true);

        return directory.path;
      }
      CrashlysticServices.instance.log('Error creating folder: ${e.toString()}');      return null;
    }
  }

  Future<bool> checkStoragePermission() async {
    // No need to ask this permission on Android 13 (API 33)
    try {
      if (Platform.isAndroid) {
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        if ((info.version.sdkInt ?? 0) >= 33) return true;
      }
      PermissionStatus perimission =
          await PermissionAppService.initPermissionStorage();

      return perimission.isGranted ?? false;
    } catch (_) {
      return false;
    }
  }
}

enum DownloadStatus {
  saveFileFailed,
  noPerrmission,
  successed,
  callFailed,
  createPathFailed
}
