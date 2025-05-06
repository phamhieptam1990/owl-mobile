import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/widgets/common/common.dart';

import 'take_photo_screen.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  Future<File?> takePicture({int imageQuality = 70}) async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final statusCamera = await Permission.camera.status;

      if (!statusCamera.isGranted) {
        await WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng chọn cấp quyền camera để sử dụng tính này!',
          callbackOK: () async => openAppSettings(),
        );
        return null;
      }

      if (Platform.isAndroid) {
        final imagePath = await Navigator.push<String>(
          NavigationService.instance.navigationKey.currentContext!,
          MaterialPageRoute(builder: (context) => TakePhotoScreen()),
        );
        if (imagePath != null) {
          return File(imagePath);
        }
      } else {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera, 
          imageQuality: imageQuality,
        );
        if (pickedFile?.path.isNotEmpty == true) {
          imageFile = File(pickedFile?.path ?? '');
          return imageFile;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  Future<File?> selfie({
    int imageQuality = 70,
    CameraDevice preferredCameraDevice = CameraDevice.front
  }) async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final statusCamera = await Permission.camera.status;

      if (!statusCamera.isGranted) {
        await WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng chọn cấp quyền camera để sử dụng tính này!',
          callbackOK: () async => openAppSettings(),
        );
        return null;
      }

      if (Platform.isAndroid) {
        final imagePath = await Navigator.push<String>(
          NavigationService.instance.navigationKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => TakePhotoScreen(
              isForceSelfie: true,
            ),
          ),
        );
        if (imagePath != null) {
          return File(imagePath);
        }
      } else {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera, 
          imageQuality: imageQuality,
        );
        if (pickedFile?.path.isNotEmpty == true) {
          imageFile = File(pickedFile?.path ?? '');
          return imageFile;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error taking selfie: $e');
      return null;
    }
  }

  Future<File?> forceSelfie({
    CameraDevice preferredCameraDevice = CameraDevice.front
  }) async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final statusCamera = await Permission.camera.status;

      if (!statusCamera.isGranted) {
        await WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng chọn cấp quyền camera để sử dụng tính này!',
          callbackOK: () async => openAppSettings(),
        );
        return null;
      }

      String? imagePath;
      if (Platform.isAndroid) {
        final deviceAndroid = await DeviceInfoPlugin().androidInfo;
        
        if (deviceAndroid.version.release == '13' || deviceAndroid.version.sdkInt! >= 33) {
          final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
          imagePath = pickedFile?.path;
        } else {
          imagePath = await Navigator.push<String>(
            NavigationService.instance.navigationKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TakePhotoScreen(
                isForceSelfie: true,
              ),
            ),
          );
        }
      } else {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
        imagePath = pickedFile?.path;
      }

      if (imagePath != null) {
        return File(imagePath);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error during force selfie: $e');
      return null;
    }
  }

  Future<File?> forceTakePhoto({
    CameraDevice preferredCameraDevice = CameraDevice.front
  }) async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final statusCamera = await Permission.camera.status;

      if (!statusCamera.isGranted) {
        await WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng chọn cấp quyền camera để sử dụng tính này!',
          callbackOK: () async => openAppSettings(),
        );
        return null;
      }

      String? imagePath;
      if (Platform.isAndroid) {
        final deviceAndroid = await DeviceInfoPlugin().androidInfo;
        
        if (deviceAndroid.version.release == '13' || deviceAndroid.version.sdkInt! >= 33) {
          final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
          imagePath = pickedFile?.path;
        } else {
          imagePath = await Navigator.push<String>(
            NavigationService.instance.navigationKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TakePhotoScreen(
                isForceSelfie: false,
              ),
            ),
          );
        }
      } else {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
        imagePath = pickedFile?.path;
      }

      if (imagePath != null) {
        return File(imagePath);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error during force take photo: $e');
      return null;
    }
  }
}