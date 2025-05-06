import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/attactment-image/image_picker_dialog-image.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/models/fileLocal.model.dart';

class ImagePickerHandlerImage {
  ImagePickerDialogImage? imagePicker;
  final ImagePicker _picker = ImagePicker();
  final AnimationController _controller;
  final ImagePickerListenerImage _listener;
  // VideoPlayerController _videoPlayerController;
  Map<String, String>? file;
  String titleDropper = 'Dropper';
  // Map<String, String> fileFinal;
  File? imageFile;
  int maxVideoSIzeInBytes = 20971520;
  ImagePickerHandlerImage(this._listener, this._controller);
  final ticketService = DMSService();

  Future getPicture() async {
    imagePicker?.dismissDialog();
    try {
      XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile == null) {
        _listener.errorttachmentsImage(true);
        return;
      }
      imageFile = File(pickedFile.path);
      if(imageFile == null) {
        _listener.errorttachmentsImage(true);
        return;
      }
      // _listener.userImage(croppedFile);
      _listener.loadingPathImage(true);
      var key = imageFile?.path.split('/').last ?? '';
      var value = imageFile?.path ?? '';
      final exp = key?.split('.').last;
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "extension": exp,
        "file": await MultipartFile.fromFile(value!, filename: key)
      });
      final response = await ticketService.uploadFile(formData);
      if (response.data != null && response.data['status'] == 0) {
        var stringLabel = response.data['data'].toString();
        var dataFinal = new FileLocal(stringLabel, key, imageFile!);
        var map = {stringLabel: dataFinal};
        _listener.userFileImage(map);
        
      } else {
        _listener.errorttachmentsImage(true);
        _listener.loadingPathImage(false);
        // WidgetCommon.showSnackbar(this._scaffoldKey, 'Cropper false');
      }
      _listener.loadingPathImage(false);
          // _listener.errorttachmentsImage(true);
      // return null;
    } catch (e) {
      _listener.errorttachmentsImage(true);
      _listener.loadingPathImage(false);
      // printLog(e);
      // return null;
    }
  }

  Future takePicture() async {
    imagePicker?.dismissDialog();
    try {
      XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (pickedFile == null) {
        _listener.errorttachmentsImage(true);
        return;
      }
      imageFile = File(pickedFile.path);
      if(imageFile == null) {
        _listener.errorttachmentsImage(true);
        return;
      }
      // _listener.userImage(croppedFile);
      _listener.loadingPathImage(true);
      var key = imageFile?.path.split('/').last;
      var value = imageFile?.path;
      final exp = key?.split('.').last;
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "extension": exp,
        "file": await MultipartFile.fromFile(value!, filename: key)
      });
      final response = await ticketService.uploadFile(formData);
      if (response.data != null && response.data['status'] == 0) {
        var stringLabel = response.data['data'].toString();
        var dataFinal = new FileLocal(stringLabel, key!, imageFile!);
        var map = {stringLabel: dataFinal};
        _listener.userFileImage(map);
      } else {
        _listener.errorttachmentsImage(true);
        _listener.loadingPathImage(false);
        // WidgetCommon.showSnackbar(this._scaffoldKey, 'Cropper false');
      }
      _listener.loadingPathImage(false);
          // return null;
    } catch (e) {
      _listener.errorttachmentsImage(true);
      _listener.loadingPathImage(false);
      // printLog(e);
      // return null;
    }
  }

  pickMultiFile(context) async {
    imagePicker?.dismissDialog();

    try {
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'jpg',
            'jpeg',
            'png',
            'xls',
            'xlsx',
            'ppt',
            'pptx'
          ],
          allowMultiple: true);

      //  file = await FilePicker.getMultiFilePath(
      // type: FileType.ANY, fileExtension: '');
      // FilePickerResult result = await FilePicker.platform.pickFiles(
      //   allowMultiple: true,
      //   type: FileType.custom,
      //   allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
      // );
      List<File> files;
      files = filePickerResult?.paths.map((path) => File(path!)).toList() ??[];

      _listener.loadingPathImage(false);
      for (var i = 0; i < files.length; i++) {
        imageFile = File(files[i].path);

        // _listener.userImage(croppedFile);
        _listener.loadingPathImage(true);
        var key = imageFile?.path.split('/').last;
        var value = imageFile?.path;
        final exp = key?.split('.').last;

        // var key = file.keys.toList()[i];
        // var value = file.values.toList()[i];
        final sizeFile = File(value ??'').lengthSync();
        if (sizeFile < maxVideoSIzeInBytes) {
          _listener.loadingPathImage(true);
          // final exp = key.split('.').last;
          final FormData formData = new FormData.fromMap({
            "fileName": key,
            "extension": exp,
            "file": await MultipartFile.fromFile(value!, filename: key)
          });
          final response = await ticketService.uploadFile(formData);
          if (response.data != null && response.data['status'] == 0) {
            var stringLabel = response.data['data'].toString();
            var dataFinal = new FileLocal(stringLabel, key!, imageFile!);
            var map = {stringLabel: dataFinal};
            _listener.userFileImage(map);
         
            _listener.loadingPathImage(false);
          } else {
            _listener.loadingPathImage(false);
            _listener.errorttachmentsImage(true);
            WidgetCommon.generateDialogOKGet(
                title: S.of(context).Alert,
                content:
                    S.of(context).UploadFileFailed + ' File: ' + i.toString(),
                textBtnClose: S.of(context).btOk);
          }
          _listener.loadingPathImage(false);
        } else {
          _listener.loadingPathImage(false);
          _listener.errorttachmentsImage(true);
          var msg = 'The size of the video is too big. Your video was ' +
              (sizeFile ~/ 20480).toString() +
              ' MB.Please upload a video which is less than ' +
              maxVideoSIzeInBytes.toString() +
              ' MB in size';
          WidgetCommon.generateDialogOKGet(
              title: S.of(context).Alert,
              content: msg,
              textBtnClose: S.of(context).btOk);
        }
      }
    } on PlatformException catch (e) {
      _listener.errorttachmentsImage(true);
      print("Unsupported operation" + e.toString());
      _listener.loadingPathImage(false);
    }
    //  var filePath = file != null ? file.keys.toString() : '...';
    // if (!mounted) return;
  }

  createkVideoPlus(context) async {
    // imagePicker.dismissDialog();
    imagePicker?.dismissDialog();
    File _video;
    File file;
    XFile? pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile == null) {
      _listener.errorttachmentsImage(true);
      return;
    }
    file = File(pickedFile.path);
    String filePath = file.path;
    if (filePath.indexOf('file://') == 0)
      filePath = filePath.split('file://')[1];
    final sizeFile = File(filePath).lengthSync();

    if (sizeFile < maxVideoSIzeInBytes) {
      _video = File(filePath);

      var key = file.path.split('/').last;
      var value = file.path;
      _listener.loadingPathImage(true);
      final exp = key.split('.').last;
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "extension": exp,
        "file": await MultipartFile.fromFile(value, filename: key)
      });
      final response = await ticketService.uploadFile(formData);
      if (response.data != null && response.data['status'] == 0) {
        var stringLabel = response.data['data'].toString();

        final Response responseRe =
            await ticketService.getResources(stringLabel);
        if (responseRe.data != null && responseRe.data['status'] == 0) {
          var dataFinal = responseRe.data['data'][0];
          var map = {stringLabel: dataFinal};
          _listener.funcattachmentsImage(stringLabel);
          _listener.userFileImage(map);
        } else {
          WidgetCommon.generateDialogOKGet(
              title: S.of(context).Alert,
              content: S.of(context).UploadFileFailed,
              textBtnClose: S.of(context).btOk);
          //  _listener.loadingPath(false);
        }
      } else {
        WidgetCommon.generateDialogOKGet(
            title: S.of(context).Alert,
            content: S.of(context).UploadFileFailed,
            textBtnClose: S.of(context).btOk);
      }
      _listener.loadingPathImage(false);
        } else {
      var msg = 'The size of the video is too big. Your video was ' +
          (sizeFile ~/ 20480).toString() +
          ' MB.Please upload a video which is less than ' +
          maxVideoSIzeInBytes.toString() +
          ' MB in size';
      WidgetCommon.generateDialogOKGet(
          title: S.of(context).Alert,
          content: msg,
          textBtnClose: S.of(context).btOk);
    }
  }

  void init() {
    imagePicker = new ImagePickerDialogImage(this, _controller);
    imagePicker?.initState();
  }

  // Future cropImage(File image) async {
  //   File croppedFile = await ImageCropper.cropImage(
  //     sourcePath: image.path,
  //     // ratioX: 1.0,
  //     // ratioY: 1.0,
  //     maxWidth: 512,
  //     maxHeight: 512,
  //   );
  //   _listener.userImage(croppedFile);
  // }
  static const MethodChannel _channel =
      const MethodChannel('plugins.hunghd.vn/image_cropper');

  showDialog(BuildContext context) {
    imagePicker?.getImage(context);
  }
}

abstract class ImagePickerListenerImage {
  userImageImage(File _image);
  userFileImage(Map<String, dynamic> _paths);
  loadingPathImage(bool loading);
  //  var namesGrowable = new List<String>();
  funcattachmentsImage(String attachments);
  errorttachmentsImage(bool error);
}
