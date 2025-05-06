import 'dart:io';
import 'dart:typed_data';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewPDFWidget extends StatefulWidget {
  final url;
  final title;
  final isDownload;
  ViewPDFWidget({Key? key, required this.url, this.title, this.isDownload})
      : super(key: key);
  @override
  _ViewPDFWidgetState createState() => _ViewPDFWidgetState();
}

class _ViewPDFWidgetState extends State<ViewPDFWidget> with AfterLayoutMixin {
  String? filePath;
  File? filePdf;
  final saveFileService = new SaveFileService();
  final int _initialPage = 0;
  int _actualPageNumber = 0, _allPagesCount = 0;
  PDFViewController? _pdfController;
  Uint8List? bodyBytes;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  Widget showPDF() {
    if (widget.url != null && widget.url.isNotEmpty) {
      return SizedBox.expand(
          child: PDFView(
            pdfData:bodyBytes, // là path tới file PDF đã tải về hoặc trong assets
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageSnap: false,
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
      );
    }
    return const NoDataWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '$_actualPageNumber/$_allPagesCount',
                style: TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 255, 255, 255)),
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
            child: isLoading ? WidgetCommon.buildCircleLoading() : showPDF()));
  }

  getHeightDevice(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  getWidthDevice(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    filePath = null;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final response = await saveFileService.getFileFromUrl(widget.url);
    if (Utils.checkIsNotNull(response)) {
      // _pdfController = PdfController(
      //   document: PdfDocument.openData(response.bodyBytes),
      //   initialPage: _initialPage,
      // );
      bodyBytes = response.bodyBytes;
    }
    setState(() {
      this.isLoading = false;
    });
  }
}
