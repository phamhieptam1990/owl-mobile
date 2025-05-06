import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/attactment/image_picker_dialog.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/models/fileLocal.model.dart';

class ImagePickerHandler {
   ImagePickerDialog? imagePicker;
  final ImagePicker _picker = ImagePicker();
   AnimationController _controller;
   ImagePickerListener _listener;
  // VideoPlayerController _videoPlayerController;
  Map<String, String>? file;
  String titleDropper = 'Dropper';
  // Map<String, String> fileFinal;
  File? imageFile;
  int maxVideoSIzeInBytes = 20971520;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ImagePickerHandler(this._listener, this._controller);
  final ticketService = DMSService();

  Future<void> getPicture() async {
    imagePicker?.dismissDialog();
    try {
      XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
            if (pickedFile == null) {
 _listener.loadingPath(false);
        return;
            }

      imageFile = File(pickedFile.path);

      // _listener.userImage(croppedFile);
      _listener.loadingPath(true);
      var key = imageFile?.path.split('/').last??'';
      var value = imageFile?.path??'';
      final exp = key.split('.').last??'';
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "extension": exp,
        "file": await MultipartFile.fromFile(value, filename: key)
      });
      final response = await ticketService.uploadFile(formData);
      if (response.data != null && response.data['status'] == 0) {
        var stringLabel = response.data['data'].toString();
        var dataFinal = new FileLocal(stringLabel, key, imageFile!);
        var map = {stringLabel: dataFinal};
        _listener.userFile(map);
      } else {
        _listener.loadingPath(false);
        _listener.errorttachments(true);
        // WidgetCommon.showSnackbar(this._scaffoldKey, 'Cropper false');
      }
      _listener.loadingPath(false);
          // return null;
    } catch (e) {
      _listener.errorttachments(true);
      _listener.loadingPath(false);
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
        _listener.loadingPath(false);
        return;
      }
      imageFile = File(pickedFile.path);
      if(imageFile == null) {
        _listener.loadingPath(false);
        return;
      }
      // _listener.userImage(croppedFile);
      _listener.loadingPath(true);
      var key = imageFile?.path.split('/').last??'';
      var value = imageFile?.path??'';
      final exp = key?.split('.').last??'';
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "extension": exp,
        "file": await MultipartFile.fromFile(value, filename: key)
      });
      final response = await ticketService.uploadFile(formData);
      if (response.data != null && response.data['status'] == 0) {
        var stringLabel = response.data['data'].toString();
        var dataFinal = new FileLocal(stringLabel, key, imageFile!);
        var map = {stringLabel: dataFinal};
        _listener.userFile(map);
      } else {
        _listener.loadingPath(false);
        _listener.errorttachments(true);
        // WidgetCommon.showSnackbar(this._scaffoldKey, 'Cropper false');
      }
      _listener.loadingPath(false);
          // return null;
    } catch (e) {
      _listener.errorttachments(true);
      _listener.loadingPath(false);
      // printLog(e);
      // return null;
    }
  }

  pickMultiFile(context) async {
    imagePicker?.dismissDialog();
    // _listener.loadingPath(true);
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
      if (filePickerResult == null) {
        _listener.loadingPath(false);
        return;
      }
      List<File> files;
      files = filePickerResult?.paths.map((path) => File(path!)).toList() ??[];

      _listener.loadingPath(false);
      for (var i = 0; i < files.length; i++) {
        imageFile = File(files[i].path);

        // _listener.userImage(croppedFile);
        _listener.loadingPath(true);
        var key = imageFile?.path.split('/').last ??'';
        var value = imageFile?.path ??'';
        final exp = key?.split('.').last;

        // var key = file.keys.toList()[i];
        // var value = file.values.toList()[i];
        final sizeFile = File(value).lengthSync();
        if (sizeFile < maxVideoSIzeInBytes) {
          _listener.loadingPath(true);
          // final exp = key.split('.').last;
          final FormData formData = new FormData.fromMap({
            "fileName": key,
            "extension": exp,
            "file": await MultipartFile.fromFile(value, filename: key)
          });
          final response = await ticketService.uploadFile(formData);
          if (response.data != null && response.data['status'] == 0) {
            var stringLabel = response.data['data'].toString();
            var dataFinal = new FileLocal(stringLabel, key, imageFile!);
            var map = {stringLabel: dataFinal};
            _listener.userFile(map);
           
            _listener.loadingPath(false);
          } else {
            _listener.loadingPath(false);
            _listener.errorttachments(true);
            WidgetCommon.generateDialogOKGet(
                title: S.of(context).Alert,
                content:
                    S.of(context).UploadFileFailed + ' File: ' + i.toString(),
                textBtnClose: S.of(context).btOk);
          }
          _listener.loadingPath(false);
        } else {
          _listener.loadingPath(false);
          _listener.errorttachments(true);
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
    } on PlatformException catch (_) {
      _listener.errorttachments(true);
      _listener.loadingPath(false);
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
    file = File(pickedFile?.path ??'');
    String filePath = file.path;
    if (filePath.indexOf('file://') == 0)
      filePath = filePath.split('file://')[1];
    final sizeFile = File(filePath).lengthSync();

    if (sizeFile < maxVideoSIzeInBytes) {
      _video = File(filePath);

      var key = file.path.split('/').last;
      var value = file.path;
      _listener.loadingPath(true);
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
          _listener.funcattachments(stringLabel);
          _listener.userFile(map);
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
      _listener.loadingPath(false);
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
    imagePicker = new ImagePickerDialog(this, _controller);
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

abstract class ImagePickerListener {
  userImage(File _image);
  userFile(Map<String, dynamic> _paths);
  loadingPath(bool loading);
  //  var namesGrowable = new List<String>();
  funcattachments(String attachments);
  errorttachments(bool error);
}
