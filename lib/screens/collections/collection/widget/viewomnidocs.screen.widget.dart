import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/models/tickets/document.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/widgets/common/view_html/ViewHtmlWidget.dart';

class ViewOmniDocsScreen extends StatefulWidget {
  ViewOmniDocsScreen({Key? key}) : super(key: key);
  @override
  _ViewOmniDocsScreenState createState() => _ViewOmniDocsScreenState();
}

class _ViewOmniDocsScreenState extends State<ViewOmniDocsScreen>
    with AfterLayoutMixin {
  final collectionService = new CollectionService();
  final customerService = new CustomerService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'ViewOmniDocsScreen');
  TicketModel? ticketModelParams;
  bool isLoading = true;
  List<DocumentOmniChannelModel> lstDocumentOmniChannel = [];
  final lstAppId = [];
  // final refCodes = [];
  String appId = '';
  String tokenVNG = '';
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      final listTemp = [];
      this.appId = ticketModelParams?.contractId ?? '';
      // final Response addresses =
      //     await collectionService.getObjectByTicketAggId('20161103-0000487');
      final Response addresses =
          await collectionService.getObjectXfile(this.appId);
      if (Utils.checkRequestIsComplete(addresses)) {
        final addressTemp = Utils.handleRequestData(addresses);
        if (Utils.isArray(addressTemp['data'])) {
          for (var address in addressTemp['data']) {
            listTemp.add(address);
          }
        }
      }
      for (int index = 0; index < listTemp.length; index++) {
        Response ticketModelDto = await collectionService
            .getObjWithDocsGroupedByDocType(listTemp[index]['aggId']);
        if (Utils.checkRequestIsComplete(ticketModelDto)) {
          final ticketModelData = Utils.handleRequestData(ticketModelDto);
          if (Utils.checkIsNotNull(ticketModelData['groupedDocs'])) {
            final documentsParents = ticketModelData['groupedDocs'];
            if (Utils.isArray(documentsParents)) {
              for (var documentsParent in documentsParents) {
                final documents = documentsParent['docs'];
                final docTypes = documentsParent['docType'];
                String docTypeName = '';
                if (Utils.checkIsNotNull(docTypes)) {
                  docTypeName = docTypes['docTypeName'];
                  lstAppId.add(docTypeName);
                }

                if (Utils.isArray(documents)) {
                  for (var document in documents) {
                    if (document != null) {
                      document['docTypeName'] = docTypeName;
                      // this.refCodes.add(document['refCode']);
                      lstDocumentOmniChannel
                          .add(new DocumentOmniChannelModel.fromJson(document));
                      setState(() {
                        if (isLoading) {
                          isLoading = false;
                        }
                      });
                    }
                  }
                }
              }
            }
          }
        }
      }
      // setState(() {
      //   isLoading = false;
      // });
    } catch (e) {
      print(e);
      isLoading = false;
      setState(() {});
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Widget viewOmniChannel() {
    try {
      return Card(
          child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                  child: Text(appId.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            (lstDocumentOmniChannel.length > 0)
                ? Container(
                    width: AppState.getWidthDevice(context),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lstDocumentOmniChannel.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              await viewDocument(
                                  lstDocumentOmniChannel[index], index);
                            },
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 0.0, bottom: 0, top: 0, right: 8.0),
                              title: Text(
                                lstDocumentOmniChannel[index].fileName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: AppFont.fontSize16),
                              ),
                              // subtitle: Text(
                              //   lstDocumentOmniChannel[index].documentDescription,
                              //   maxLines: 3,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: TextStyle(fontSize: AppFont.fontSize16),
                              // ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppColor.blackOpacity),
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  )
                : NoDataWidget()
          ],
        ),
      ));
    } catch (e) {
      print(e);
      return NoDataWidget();
    }
  }

  Widget viewOmniChannelNew() {
    List<Widget> lstWidget = [];
    for (int index = 0; index < lstAppId.length; index++) {
      lstWidget.add(Card(
          child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 5),
                  child: Text(lstAppId[index],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            buildWidgetOmniDoc(lstAppId[index])
          ],
        ),
      )));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                      visible: ticketModelParams?.flagCash24 == 1,
                      child: Icon(
                        Icons.flag,
                        size: 28.0,
                        color: AppColor.orange,
                      )),
                  Text('${ticketModelParams?.contractId}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Column(children: lstWidget),
      ],
    );
  }

  Widget buildWidgetOmniDoc(String appId) {
    List<DocumentOmniChannelModel> lst = [];
    for (int index = 0; index < lstDocumentOmniChannel.length; index++) {
      DocumentOmniChannelModel doc = lstDocumentOmniChannel[index];
      if (doc.docTypeName == appId && (doc.fileName?.isNotEmpty ?? false)) {
        lst.add(doc);
      }
      // if (doc?.fileName?.isNotEmpty ?? false) {
      //   lst.add(doc);
      // }
    }
    if (lst.length > 0) {
      return Container(
        width: AppState.getWidthDevice(context),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: lst.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () async {
                  await viewDocument(lst[index], index);
                },
                // child: ListTile(
                //   dense: true,
                //   contentPadding:
                //       EdgeInsets.only(left: 0.0, bottom: 0, top: 0, right: 8.0),
                //   title: Text(
                //     lst[index].documentName,
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(fontSize: AppFont.fontSize16),
                //   ),
                //   minLeadingWidth: 1,
                // )
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
                    child: Text(
                      lst[index].fileName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          color: (index % 2 == 0)
                              ? AppColor.primary
                              : AppColor.black),
                    )));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      );
    }
    return NoDataWidget();
    // return WidgetCommon.buildCircleLoading();
  }

  Widget formDetail() {
    try {
      return viewOmniChannelNew();
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
   if (ticketModelParams == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is TicketModel) {
        ticketModelParams = args;
      }
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(title: 'Tài liệu/ hình ảnh của hợp đồng', lstWidget: []),
        body: Container(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: (isLoading == true)
                  ? Container(
                      height: AppState.getHeightDevice(context),
                      width: AppState.getWidthDevice(context),
                      child: ShimmerCheckIn())
                  : formDetail()),
        ));
  }

  Future<void> viewDocument(
      DocumentOmniChannelModel document, int index) async {
    try {
      if (!Utils.checkIsNotNull(document.objId)) {
        WidgetCommon.showSnackbar(_scaffoldKey, 'Không có mã tài liệu');
        return;
      }
      if (document.objId?.isEmpty ?? true) {
        WidgetCommon.showSnackbar(_scaffoldKey, 'Không có mã tài liệu');
        return;
      }
      // if (this.tokenVNG.isEmpty) {
        WidgetCommon.showLoading();
        List<String> refCodes = Utils.checkIsNotNull(document.refCode) ? [document.refCode ?? ''] : [];
        if(Utils.isArray(refCodes)){
          this.tokenVNG  = '';
          final tokenVNG = await collectionService.getTokenVNG(refCodes);
          if (Utils.checkRequestIsCompleteEnhace(tokenVNG)) {
            final tokenTemp = tokenVNG.data;
            if (Utils.checkIsNotNull(tokenTemp)) {
              this.tokenVNG = tokenTemp['access_token'];
            }
          }
        }
        WidgetCommon.dismissLoading();
      // }
      if (this.tokenVNG.isEmpty) {
        return;
      }

      NavigationService.instance.navigateToRoute(MaterialPageRoute(
          builder: (context) => ViewHtmlWidget(
              docId: document?.refCode ?? '',
              mineType: document?.mimeType ?? '',
              accessToken: this.tokenVNG)));
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
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
