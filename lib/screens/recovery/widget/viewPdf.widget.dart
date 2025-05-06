import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/generate_job_response.dart';
import 'package:athena/screens/recovery/recovery.provider.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/getit.dart';
import '../constant.recovery.dart';

class ViewPdfScreen extends StatefulWidget {
  final String templateCode;
  final int id;
  final String name;
  ViewPdfScreen(
      {Key? key,
      required this.templateCode,
      required this.id,
      required this.name})
      : super(key: key);
  @override
  _ViewPdfScreenState createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  final _saveFileService = new SaveFileService();
  final _recoveryProvider = getIt<RecoveryProvider>();
  bool _isLoading = true;
  bool _isLoadFailed = false;
  bool _isDownloadSucess = false;
  final int _initialPage = 0;
  int _actualPageNumber = 0, _allPagesCount = 0;
  // PDFDocument document;
   File? filePdf;
   PDFViewController? _pdfController;
  @override
  initState() {
    initData();
    super.initState();
  }

  void initData() async {
    try {
      var params = {
        "templateCode": this.widget.templateCode,
        "params": {"id": this.widget.id}
      };
      final response = await _saveFileService.postTequestDownLoadFile(
          RecoveryConstant.DOWNLOAD_PDF, params);
      final generateJobResponse =
          GenerateJobResponse.fromJson(jsonDecode(response?.body ?? ''));

      var dataPdf = await _saveFileService.getDownLoadFile(IcollectConst
              .dowwnloadJobVF +
          'fileName=${generateJobResponse.data?.fileName}&pathByCurrentDate=${generateJobResponse.data?.pathByCurrentDate}');
      if (dataPdf == null) {
        await Future.delayed(Duration(seconds: 10));
        dataPdf = await _saveFileService.getDownLoadFile(IcollectConst
                .dowwnloadJobVF +
            'fileName=${generateJobResponse.data?.fileName}&pathByCurrentDate=${generateJobResponse.data?.pathByCurrentDate}');
        if (dataPdf == null) {
          _isLoading = false;
          setState(() {});

          WidgetCommon.generateDialogOKGet(
              content:
                  'Quá trình xuất file đang được hệ thống xử lý. Vui lòng kiểm tra trạng thái file ${generateJobResponse.data?.fileName} tại mục (Cấu Hình -> Danh sách tải về)',
              textBtnClose: 'Đã hiểu',
              callback: () {
                Navigator.of(context)
                    .pushReplacementNamed(RouteList.DOWNLOAD_LIST_SCREEN);
              });
          return;
        }
      }
      if (Utils.checkIsNotNull(dataPdf)) {
        String fileName = this.widget.templateCode.toString() +
            '_' +
            this.widget.id.toString() +
            '.pdf';
        filePdf = await _saveFileService
            .handleDownLoadFilePDF(fileName, dataPdf, isStored: true);
        if (Utils.checkIsNotNull(filePdf)) {
          // _pdfController = PdfController(
          //   document: PdfDocument.openFile(filePdf.path),
          //   initialPage: _initialPage,
          // );
          _isDownloadSucess = true;
        }
      }
      _isLoading = false;

      setState(() {});
    } catch (e) {
      print(e);
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          title: Text(this.widget.name),
          actions: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '$_actualPageNumber/$_allPagesCount',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  if (Utils.checkIsNotNull(filePdf)) {
                    Share.shareXFiles([XFile(filePdf?.path ??'')],
                        subject: 'Athena Owl share ' + this.widget.templateCode,
                        text: this.widget.templateCode);
                    return;
                  } else {
                    WidgetCommon.generateDialogOKGet(
                        content: 'Không tìm thấy tập tin');
                  }
                },
                child: Icon(Icons.share),
              ),
              width: 40,
            )
          ],
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : showPDF(),
        ));
  }

  Widget showPDF() {
    if (_isDownloadSucess) {
      // return PDFViewer(document: document);
      // return PdfView(
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
      // );
      return PDFView(
        filePath:
            filePdf?.path, // là path tới file PDF đã tải về hoặc trong assets
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
      );
    }
    return NoDataWidget();
  }

  @override
  void dispose() {
    WidgetCommon.dismissLoading();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
