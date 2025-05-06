import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/screens/customer-request/attactment/image_picker_handler.dart';
import 'package:athena/screens/customer-request/customer-request.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';
import 'package:http/http.dart' show get;

class EditRequestMoreInfoScreen extends StatefulWidget {
  final String aggId;
  final String action;
  EditRequestMoreInfoScreen({
    Key? key,
    required this.aggId,
    required this.action,
  }) : super(key: key);
  @override
  _EditRequestMoreInfoScreenState createState() =>
      _EditRequestMoreInfoScreenState();
}

class _EditRequestMoreInfoScreenState extends State<EditRequestMoreInfoScreen>
    with TickerProviderStateMixin, AfterLayoutMixin, ImagePickerListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamic format = new DateFormat('dd/MM/yyyy  HH:mm:ss');
  dynamic dataStatusCode = [];
  Map<String, dynamic> _paths = {};
  dynamic dataFinal, dataFinalFormat;
  bool _loadingPath = true;
  dynamic attachmentFile = [];
  DMSService _dmsService = new DMSService();
  List<FileLocal> galleryItemHistoryLocal = [];
  ImagePickerHandler? imagePicker;
  AnimationController? _controller;
  List<String> _attachments = [];
  File? _image;
  final _customerRequestservice = new CustomerRequestService();
  @override
  initState() {
    super.initState();
    Map<String, Object> dataEmpty = new Map();
    dataFinal = {'fcsp_more_info_note': '', 'fcsp_more_info_attachment': []};
    dataFinalFormat = dataEmpty;
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller!);
    imagePicker?.init();
  }

  void removeList(context, keyValue) {
    WidgetCommon.generateDialogOKCancelGet(S.of(context).deleteFile,
        title: S.of(context).Alert, callbackOK: () {
      removeFile(keyValue);
    },
        callbackCancel: () {},
        textBtnOK: S.of(context).btOk,
        textBtnClose: S.of(context).btExit);
  }

  removeFile(String keyValue) {
    setState(() {
      _paths.removeWhere((key, value) => key == keyValue);
      setImageFile();
    });
  }

  userImage(File _image) {
    setState(() {
      // Image.file(_image);
      this._image = _image;

      // _paths
    });
  }

  // @override
  userFile(Map<String, dynamic> paths) {
    setState(() {
      // Image.file(_image);
      if (_paths.isEmpty || _paths.length == 0) {
        _paths = paths;
      } else
        paths.forEach((k, v) => _paths[k] = v);
      // _count++;
      // _paths = paths;
      setImageFile();
    });
  }

  funcattachments(String attachments) {
    setState(() {
      if (this._attachments.isEmpty ||
          this._attachments.length == 0) {
        this._attachments = [attachments];
      } else
        this._attachments.add(attachments);
      // this._attachments.add(attachments);
      // _paths = paths;
    });
  }

  errorttachments(bool error) {
    if (error) {
      WidgetCommon.showSnackbar(_scaffoldKey, "Tải file đính kèm thất bại!");
      return;
    }
  }

  loadingPath(bool loading) {
    setState(() {
      // Image.file(_image);
      this._loadingPath = loading;
    });
  }

  handleSendRequest(BuildContext context) async {
    var listFinalAttachment = [];
    if (_paths.length > 10) {
      WidgetCommon.showSnackbar(
          _scaffoldKey, "Số lượng file không được lớn hơn 10");
      return;
    }
    if (_paths.length > 0) {
      for (var i = 0; i < _paths.length; i++) {
        var value = _paths.keys.toList()[i].toString();
        if (listFinalAttachment.isEmpty ||
            listFinalAttachment.length == 0) {
          listFinalAttachment = [value];
        } else
          listFinalAttachment.add(value);
      }
      dataFinal['fcsp_more_info_attachment'] = listFinalAttachment;
    }
    try {
      final Response res = await this
          ._customerRequestservice
          .actionTicketEdit(context, dataFinal, widget.aggId, dataFinalFormat);

      if (Utils.checkRequestIsComplete(res)) {
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: AppColor.blue);
        startTime();
        return;
      }
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
    } catch (e) {
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
      return;
    }
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context, true);
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (widget.action == AppStateConfigConstant.EDIT_LOG) {}
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: TextFormField(
            // readOnly: true,
            controller:
                TextEditingController(text: dataFinal['fcsp_more_info_note']),
            onSaved: (value) {
              // setState(() {
              dataFinal['fcsp_more_info_note'] = value;
              // });
            },
            onChanged: (value) {
              // setState(() {
              dataFinal['fcsp_more_info_note'] = value;
              // });
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            validator: (val) => Utils.isRequire(context, val ?? ''),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: S.of(context).note,
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
        new Container(
            // height: 500,
            padding: EdgeInsets.all(16),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text('File đính kèm')),
                  new InkWell(
                    child: new Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(5.0),
                        color: Colors.black12,
                      ),
                      width: AppState.getWidthDevice(context),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add_box_rounded,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    onTap: () async {
                      showDialog();
                    },
                  )
                ])),
        _paths.length > 0
            ? Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Danh sách file đính kèm' +
                      ' (' +
                      _paths.length.toString() +
                      ')',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              )
            : new Container(),
        _paths.length > 0 ? buildAtt(context) : Container(),
      ],
    );
  }

  showDialog() {
    FocusScope.of(context).unfocus();
    imagePicker?.showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      appBar: AppBarCommon(title: 'Thêm thông tin', lstWidget: [
        widget.action == AppStateConfigConstant.EDIT_LOG
            ? IconButton(
                icon: const Icon(Icons.save),
                tooltip: S.of(context).btCreate,
                onPressed: () {
                  // reset(context);
                  handleSendRequest(context);
                },
              )
            : Container(),
      ]),
      body: SingleChildScrollView(
        child: buildScreen(),
        reverse: false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget buildAtt(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[buildListImage(), buildListFile()]));
  }

  Widget buildListFile() {
    return new ListView.builder(
      // scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: attachmentFile.length,
      itemBuilder: (context, int index) {
        final imageFile = attachmentFile[index];
        var key = imageFile.file.path.split('/').last;
        final exp = key.split('.').last;
        return buildFile(index, exp);
      },
    );
  }

  Widget buildListImage() {
    List<Widget> lstWidget = [];
    // galleryItemHistoryLocal[0].file.absolute.
    for (int index = 0; index < galleryItemHistoryLocal.length; index++) {
      //  galleryItemHistoryLocal[index].file.readAsBytes();
      lstWidget.add(Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Container(
              child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Container(
                height: 100.0,
                width: 100.0,
                child: TextButton(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(children: <Widget>[
                        Image.file(
                            File(galleryItemHistoryLocal[index].file.path),
                            width: 80.0,
                            height: 80.0),
                        Positioned(
                            right: -5,
                            top: -9,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 25,
                              ),
                              onPressed: () {
                                removeList(context,
                                    galleryItemHistoryLocal[index].key);
                              },
                            )),
                      ])),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          dataPost: [],
                          galleryItems: galleryItemHistoryLocal,
                          initialIndex: index,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                )),
          ))));
    }
    return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: lstWidget);
  }

  openFileLocalPath(path) {
    try {
      OpenFilex.open(path.toString());
    } catch (e) {}
  }

  Widget buildFile(index, exp) {
    final imageFile = attachmentFile[index];
    var fileName = imageFile.file.path.split('/').last;
    final exp = fileName.split('.').last;
    final sizeFile = imageFile.file.lengthSync();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      // padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              onTap: () => {
                    openFileLocalPath(imageFile.file.path)
                    // saveImage(context, attachmentFile[index]['fileName'],
                    //     attachmentFile[index]['refCode'])
                  },
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  exp.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: AppColor.white),
                ),
              ),
              title: Text(
                fileName,
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
              // subtitle: Text(
              //     item['size'].toString() + ' Byte'),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text('Size: ' + sizeFile.toString() + ' Byte'),
                    // new Text(mimeType),
                  ]),
              trailing: new InkWell(
                  onTap: () => removeList(context, _paths.keys.toList()[index]),
                  child: new Stack(children: <Widget>[Icon(Icons.delete)])))
        ],
      ),
    );
  }

  // void saveImage(context, String filename, keyValue) async {
  //   setState(() {
  //     _loadingPath = true;
  //   });
  //   HttpClient client = new HttpClient();
  //   final storageToken =
  //       await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
  //   var _downloadData = List<int>();
  //   var sObject = 'identifer=' + keyValue;
  //   // var url = APP_CONFIG.DOWNLOAD_FILE + sObject;
  //   var url = DMS_SERVICE_URL.DOWNLOAD_FILE'] + sObject;
  //   var namfirst = DateTime.now().millisecondsSinceEpoch;
  //   final fileSave = await localFile(filename);
  //   try {
  //     var request = await client.getUrl(Uri.parse(url));
  //     request.headers
  //         .set("Authorization", APP_CONFIG.KEY_JWT + '$storageToken');
  //     await requestClose(request).then((HttpClientResponse response) {
  //       response.listen((d) => _downloadData.addAll(d), onDone: () {
  //         openFileLocal(fileSave, _downloadData);
  //       });
  //     });
  //   } catch (exception) {
  //     setState(() {
  //       _loadingPath = false;
  //     });
  //     // setState(() => _loadingPath = false);
  //     WidgetCommon.showSnackbar(
  //         this._scaffoldKey, S.of(context).DownloadFileFailed);
  //   }
  // }

  // openFileLocal(fileSave, _downloadData) async {
  //   setState(() {
  //     _loadingPath = false;
  //   });
  //   await fileSave.writeAsBytes(_downloadData);
  //   var pathFile = fileSave.path;

  //   OpenFile.open(pathFile.toString());
  // }

  Future<File> localFile(String filename) async {
    final path = await localPath;
    // var now = 'Test' + '.' + filename.split('.').last;
    // filename = 'test.txt';
    // var now = new DateTime.now().toString() +'.'+ filename.split('.').last;
    return File('$path/$filename');
  }

  Future<String> get localPath async {
    //  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    final dir = await getApplicationDocumentsDirectory();
    // var documentDirectory = await getApplicationDocumentsDirectory();
    // String firstPath = documentDirectory.path + "/images";
    return dir.path;
  }

  requestClose(request) {
    return request.close();
  }

  setAtt(attachment) async {
    var lengthAtt = attachment.length;
    var array = [];
    for (var index = 0; index < lengthAtt; index++) {
      array.add('"' + attachment[index].toString() + '"');
    }
    try {
      final Response responseAtt = await _dmsService.getResourcesList(array);
      if (Utils.checkRequestIsComplete(responseAtt)) {
        // var data= responseAtt.data['data'];
        var data = Utils.handleRequestData(responseAtt);
        if (Utils.isArray(data)) {
          Map<String, dynamic> arrayAtt = {};
          for (var i = 0; i < data.length; i++) {
            var string = data[i]['refCode'];
            var dynamicValue = data[i];
            Map<String, dynamic> paths = {};
            paths = {string: dynamicValue};
            if (arrayAtt.isEmpty || arrayAtt.length == 0) {
              arrayAtt = paths;
            } else
              paths.forEach((k, v) => arrayAtt[k] = v);
          }
          setState(() {
            _paths = arrayAtt;
          });
          setImageFile();
        }
      }
    } catch (e) {}
  }

  void saveImage(context, String filename, keyValue) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        openFileLocal(filename, fileSave, response);
      }
        } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> openFileLocal(
      String fileName, dynamic fileSave, dynamic _downloadData) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      setState(() {
        _loadingPath = false;
      });
      OpenFilex.open(filePathAndName.toString());
      // galleryItemHistoryLocal
      //     .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      // setState(() {});
    } catch (e) {}
  }

  void saveFileImage(context, key, String filename, keyValue) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        handleDownLoadFile(filename, fileSave, response, key, keyValue);
      }
        } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> handleDownLoadFile(String fileName, dynamic fileSave,
      dynamic _downloadData, int key, keyValue) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      setState(() {
        if (galleryItemHistoryLocal.isEmpty ||
            galleryItemHistoryLocal.length == 0) {
          // galleryItemHistory = [File(fileSave.path)];
          galleryItemHistoryLocal = [
            FileLocal(keyValue.toString(), fileName, File(filePathAndName))
          ];
        } else
          galleryItemHistoryLocal.add(
              FileLocal(keyValue.toString(), fileName, File(filePathAndName)));
      });
      // galleryItemHistoryLocal
      //     .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      // setState(() {});
    } catch (e) {}
  }

  // void saveFileImage(context, key, String filename, keyValue) async {
  //   HttpClient client = new HttpClient();
  //   final storageToken =
  //       await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
  //   var _downloadData = List<int>();
  //   var sObject = 'identifer=' + keyValue;
  //   var url = DMS_SERVICE_URL.DOWNLOAD_FILE'] + sObject;
  //   final fileSave = await localFile(filename);
  //   try {
  //     var request = await client.getUrl(Uri.parse(url));
  //     request.headers
  //         .set("Authorization", APP_CONFIG.KEY_JWT + '$storageToken');
  //     await requestClose(request).then((HttpClientResponse response) {
  //       response.listen((d) => _downloadData.addAll(d), onDone: () {
  //         // fileSave.writeAsBytes(_downloadData);
  //         setFileLocal(
  //             context, key, filename, keyValue, fileSave, _downloadData);
  //       });
  //     });
  //   } catch (exception) {
  //     WidgetCommon.showSnackbar(
  //         this._scaffoldKey, S.of(context).DownloadFileFailed);
  //   }
  // }

  // setFileLocal(
  //     context, key, String filename, keyValue, fileSave, _downloadData) async {
  //   await fileSave.writeAsBytes(_downloadData);
  //   setState(() {
  //     if (galleryItemHistoryLocal == null ||
  //         galleryItemHistoryLocal.isEmpty ||
  //         galleryItemHistoryLocal.length == 0) {
  //       // galleryItemHistory = [File(fileSave.path)];
  //       galleryItemHistoryLocal = [
  //         FileLocal(keyValue.toString(), filename, File(fileSave.path))
  //       ];
  //     } else
  //       galleryItemHistoryLocal
  //           .add(FileLocal(key.toString(), filename, File(fileSave.path)));
  //   });
  // }

  setImageFile() {
    final postAttachment = _paths;
    setState(() {
      galleryItemHistoryLocal = [];
      attachmentFile = [];
    });
    for (var i = 0; i < postAttachment.length; i++) {
      FileLocal imageFile = postAttachment.values.toList()[i];
      var key = imageFile.file.path.split('/').last;
      final exp = key.split('.').last;
      if (Utils.checkIsImage(exp)) {
        galleryItemHistoryLocal.add(imageFile);
      } else {
        attachmentFile.add(imageFile);
      }
      // if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
      //     0) {
      //   var namfirst = DateTime.now().millisecondsSinceEpoch;
      //   saveFileImage(
      //       context,
      //       postAttachment.values.toList()[i]['makerDate'],
      //       namfirst.toString() + i.toString(),
      //       postAttachment.values.toList()[i]['refCode']);
      // } else {
      //   if (attachmentFile == null ||
      //       attachmentFile.isEmpty ||
      //       attachmentFile.length == 0) {
      //     attachmentFile = [postAttachment.values.toList()[i]];
      //   } else
      //     attachmentFile.add(postAttachment.values.toList()[i]);
      // }
    }
    // for (var i = 0; i < postAttachment.length; i++) {
    //   if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
    //       0) {
    //     var namfirst = DateTime.now().millisecondsSinceEpoch;
    //     // downloadFile(context, i, postAttachment[i]['refCode']);
    //     saveFileImage(
    //         context,
    //         postAttachment.values.toList()[i]['makerDate'],
    //         namfirst.toString() + i.toString(),
    //         postAttachment.values.toList()[i]['refCode']);
    //   } else {
    //     if (attachmentFile == null ||
    //         attachmentFile.isEmpty ||
    //         attachmentFile.length == 0) {
    //       attachmentFile = [postAttachment.values.toList()[i]];
    //     } else
    //       attachmentFile.add(postAttachment.values.toList()[i]);
    //   }
    // }
  }
}
