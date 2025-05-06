import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

import '../../../utils/log/crashlystic_services.dart';

class ViewHtmlWidget extends StatefulWidget {
  final String docId;
  final String mineType;
  final String accessToken;

  ViewHtmlWidget(
      {Key? key,
      required this.docId,
      required this.accessToken,
      required this.mineType})
      : super(key: key);
  @override
  _ViewHtmlWidgetState createState() => _ViewHtmlWidgetState();
}

class _ViewHtmlWidgetState extends State<ViewHtmlWidget> with AfterLayoutMixin {
  bool _isLoading = true;
  bool _isDownloadSucess = false;
  bool _isLoadFailed = false;
  bool _isImageFile = false;
  final int _initialPage = 0;
  int _actualPageNumber = 0, _allPagesCount = 0;
  SaveFileService saveFile = new SaveFileService();
  // PDFDocument document;
  PDFViewController? _pdfController;
  Uint8List? bodyBytes ;
  String typeImage = '';
  String storageToken = '';
  String link = '';
  var dataImageFile;
  bool _isTimeout = false;
  requestClose(request) {
    return request.close();
  }

  Future<void> saveFileImage() async {
    // String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

    String fileName = '';
    storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    // final fileSave = await localFile(fileName);
    try {
      final params = {
        "identifer": widget.docId,
        "preview": true,
        "accessToken": widget.accessToken,
        "appCode": APP_CONFIG.APP_CODE
      };
      // OMNI_SERVICE_URL.DOWNLOAD_FILE_VNG

      final response = await http.post(
          Uri.parse(XFILE_SERVICE_URL.DOWNLOAD_FILE_VNG),
          body: json.encode(params),
          encoding: Encoding.getByName("UTF-8"),
          headers: {
            'Authorization': APP_CONFIG.KEY_JWT + '$storageToken',
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          return http.Response(
              'Timeout Errors', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (Utils.checkIsNotNull(response.headers)) {
          final headers = response.headers;
          if (Utils.checkIsNotNull(headers)) {
            String headerContentType =
                headers['content-type']?.toString() ?? '';
            if (headerContentType.isEmpty ?? false) return;

            if (checkContain(headerContentType, 'image')) {
              dataImageFile = response.bodyBytes;
              _isImageFile = true;
            } else {
              fileName =
                  DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';
              return _addWatermarkToPDF(response, context);
            }
          }
        }
      }
      if (response.statusCode == 408) {
        _isTimeout = true;
      }
          _isDownloadSucess = false;
      _isLoading = false;
      setState(() {});
    } catch (exception) {
      _isDownloadSucess = false;
      _isLoading = false;
      setState(() {});
    }
  }

  bool checkContain(String headerType, String contentType) {
    if (headerType.contains(contentType) ?? false) return true;
    return false;
  }

  Future<void> handleDownLoadFile(
      String fileName, dynamic _downloadData) async {
    try {
      await _addWatermarkToPDF(_downloadData, context);
    } catch (e) {
      _isDownloadSucess = false;
    }
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await saveFileImage();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // WebView.platform = SurfaceAndroidWebView();
    }
  }

  Widget showPDF() {
    try {
      if (_isLoadFailed) {
        return Stack(children: [
          // PdfView(
          //   documentLoader: Center(child: CircularProgressIndicator()),
          //   controller: _pdfController,
          //   loaderSwitchDuration: Duration(milliseconds: 100),
          //   onDocumentLoaded: (document) {
          //     setState(() {
          //       _allPagesCount = document.pagesCount;
          //     });
          //   },
          //   onPageChanged: (page) {
          //     setState(() {
          //       _actualPageNumber = page;
          //     });
          //   },
          // ),
          PDFView(
            pdfData: bodyBytes, // là path tới file PDF đã tải về hoặc trong assets
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                _allPagesCount = _pages!;
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfController = pdfViewController;
            },
            onPageChanged: (int? current, int? total) {
              setState(() {
                _actualPageNumber = current!;
              });
            },
            onError: (error) {
              print("PDF error: $error");
            },
            onPageError: (page, error) {
              print('Error on page $page: $error');
            },
          )
        ]);
      }
      if (_isImageFile && dataImageFile != null) {
        return Stack(children: [
          Center(
            child: InteractiveViewer(
              panEnabled: false, // Set it to false
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 2,
              child: Image.memory(
                dataImageFile,
                width: AppState.getWidthDevice(context),
                height: AppState.getWidthDevice(context),
                fit: BoxFit.cover,
              ),
            ),
          )
        ]);
      }
      return NoDataWidget();
    } catch (e) {
      return NoDataWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Xem chi tiết Omnidocs'),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                '$_actualPageNumber/$_allPagesCount',
                 style: TextStyle(
                    fontSize: 18.0, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : showPDF(),
        ));
  }

  getHeightDevice(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  getWidthDevice(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  Future<void> _addWatermarkToPDF(
      dynamic _downloadData, BuildContext context) async {
    try {
      // _pdfController = PdfController(
      //   document: PdfDocument.openData(_downloadData.bodyBytes),
      //   initialPage: _initialPage,
      // );
      bodyBytes =_downloadData.bodyBytes;
      _isLoading = false;
      _isLoadFailed = true;
      _isDownloadSucess = true;
    } catch (e) {
      _isLoading = false;
      _isDownloadSucess = false;
      CrashlysticServices.instance.log(e.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    // filePdf = null;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
