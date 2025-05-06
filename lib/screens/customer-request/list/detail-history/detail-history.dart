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

class DetailHistoryScreen extends StatefulWidget {
  final String type;
  final String title;
  final dynamic entry;
  DetailHistoryScreen({
    Key? key,  // Mark as nullable
    required this.type,  // Use required keyword
    required this.title,
    required this.entry,
  }) : super(key: key);
  
  @override
  _DetailHistoryScreenState createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'DetailHistoryScreen');
  final format = DateFormat('dd/MM/yyyy  HH:mm:ss');
  List<dynamic> dataStatusCode = [];
  Map<String, dynamic> _paths = {};
  dynamic dataFinal, dataFinalFormat;
  bool _loadingPath = true;
  List<dynamic> attachmentFile = [];
  final DMSService _dmsService = DMSService();
  List<FileLocal> galleryItemHistoryLocal = [];
  
  @override
  initState() {
    Map<String, Object> dataEmpty = {};
    dataFinal = {'note': '', 'attachments': []};
    dataFinalFormat = dataEmpty;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      if (widget.type == 'FC_SUPPORT_RESUBMIT_TICKET') {
        if (Utils.checkIsNotNull(
            widget.entry['newValue']['fcsp_more_info_note'])) {
          dataFinal['note'] = widget.entry['newValue']['fcsp_more_info_note'];
        } else if (Utils.checkIsNotNull(widget.entry['note'])) {
          dataFinal['note'] = widget.entry['note'].toString();
        }
        if (widget.entry['newValue']['fcsp_more_info_attachment'].length > 0) {
          setAtt(widget.entry['newValue']['fcsp_more_info_attachment']);
        } else if (widget.entry['attachments'].length > 0) {
          setAtt(widget.entry['attachments']);
        }
      } else {
        if (Utils.checkIsNotNull(widget.entry['note'])) {
          dataFinal['note'] = widget.entry['note'].toString();
        }
        if (widget.entry['attachments'].length > 0) {
          setAtt(widget.entry['attachments']);
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: dataFinal['note'] ?? ''),
            onSaved: (value) {},
            onChanged: (value) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 20,
            validator: (val) => Utils.isRequire(context, val ?? ''),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: S.of(context).note,
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
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
            : new Container(
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
                        onTap: () async {},
                      )
                    ])),
        _paths.length > 0 ? buildAtt(context) : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      appBar: AppBarCommon(title: widget.title, lstWidget: []),
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
        final item = attachmentFile[index];
        final exp = item['fileName'].toString().split('.').last;
        final mimeType = 'MimeType: ' + item['mimeType'].toString();

        return buildFile(index, exp, mimeType);
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
                        // Positioned(
                        //     right: -5,
                        //     top: -9,
                        //     child: IconButton(
                        //       icon: Icon(
                        //         Icons.cancel,
                        //         color: Colors.red,
                        //         size: 25,
                        //       ),
                        //       onPressed: () {
                        //         // removeList(context,
                        //         //     galleryItemHistoryLocal[index].key);
                        //       },
                        //     )),
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

  Widget buildFile(index, exp, mimeType) {
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
              saveImage(context, attachmentFile[index]['fileName'],
                  attachmentFile[index]['refCode'])
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                exp.toUpperCase(),
                style: TextStyle(fontSize: 12, color: AppColor.white),
              ),
            ),
            title: Text(
              attachmentFile[index]['fileName'],
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
            // subtitle: Text(
            //     item['size'].toString() + ' Byte'),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('Size: ' +
                      attachmentFile[index]['size'].toString() +
                      ' Byte'),
                  // new Text(mimeType),
                ]),
            // trailing: new InkWell(
            //     onTap: () => removeList(context, _paths.keys.toList()[index]),
            //     child: new Stack(children: <Widget>[Icon(Icons.delete)]))
          )
          // Text(widget.images.values.toList()[index]['fileName']),
          // Text(widget.images.values.toList()[index]['mimeType'].toString()),
          // Text(widget.images.values.toList()[index]['size'].toString()),
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

  setImageFile() {
    final postAttachment = _paths;
    setState(() {
      galleryItemHistoryLocal = [];
      attachmentFile = [];
    });
    for (var i = 0; i < postAttachment.length; i++) {
      if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
          0) {
        var namfirst = DateTime.now().millisecondsSinceEpoch;
        // downloadFile(context, i, postAttachment[i]['refCode']);
        saveFileImage(
            context,
            postAttachment.values.toList()[i]['makerDate'],
            namfirst.toString() + i.toString(),
            postAttachment.values.toList()[i]['refCode']);
      } else {
        if (attachmentFile == null ||
            attachmentFile.isEmpty ||
            attachmentFile.length == 0) {
          attachmentFile = [postAttachment.values.toList()[i]];
        } else
          attachmentFile.add(postAttachment.values.toList()[i]);
      }
    }
  }
}
