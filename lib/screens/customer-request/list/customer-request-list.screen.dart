import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/customer-request/Request.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/customer-request/customer-request.provider.dart';
import 'package:athena/screens/customer-request/customer-request.screen.dart';
import 'package:athena/screens/customer-request/customer-request.service.dart';
import 'package:athena/screens/customer-request/list/customer-request-edit.screen.dart';
import 'package:athena/screens/customer-request/list/filter/filter.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/widgets/common/container/boxDecoration.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart' as search_bar_package;

class CustomerRequestListScreen extends StatefulWidget {
  final int? fillterStatus;
  CustomerRequestListScreen({Key? key, this.fillterStatus}) : super(key: key);
  @override
  _CustomerComplaintListScreenState createState() =>
      _CustomerComplaintListScreenState();
}

class _CustomerComplaintListScreenState extends State<CustomerRequestListScreen>
    with AfterLayoutMixin {
  // late search_bar_package.SearchBar searchBar;
  ScrollController scrollController =ScrollController();
  final _customerRequestService = CustomerRequestService();
  final _customerRequestSingeton = CustomerRequestSingeton();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stringQuery = '';
  TextEditingController editingController = TextEditingController();
  bool _enablePullUp = true;
  bool isFirstEnter = true;
  @override
  initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    var createdDate = new DateTime.now();
    if (widget.fillterStatus == 0) {
      _customerRequestSingeton.filter = '';
    } else if (widget.fillterStatus == 1) {
      _customerRequestSingeton.filterData['dateFrom'] = createdDate;
      _customerRequestSingeton.filterData['dateTo'] = createdDate;
    } else if (widget.fillterStatus == 2) {
      _customerRequestSingeton.filterData['dateFrom'] =
          createdDate.subtract(Duration(days: 7));
      _customerRequestSingeton.filterData['dateTo'] = createdDate;
    } else if (widget.fillterStatus == 3) {
      _customerRequestSingeton.filterData['dateFrom'] =
          createdDate.subtract(Duration(days: 30));
      _customerRequestSingeton.filterData['dateTo'] = createdDate;
    }
    await handleFetchData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // buildFiltter();
    try {
      _customerRequestSingeton.currentPage = 1;
      _customerRequestSingeton.lstRequestModel = [];
      this.isFirstEnter = true;
      setState(() {});
      await handleFetchData();
      setState(() {});
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  checkNUllFilter(filter) {
    if (Utils.checkIsNotNull(filter)) {
      return ',';
    }
    return '';
  }

  buildFiltter() {
    _customerRequestSingeton.filter = '';
    if (Utils.checkIsNotNull(
            _customerRequestSingeton.filterData['statusCode']) &&
        _customerRequestSingeton.filterData['statusCode'] != 'all') {
      _customerRequestSingeton.filter += checkNUllFilter(
              _customerRequestSingeton.filter) +
          '"statusCode":{"values":["${_customerRequestSingeton.filterData['statusCode']}"],"filterType":"set"}';
    }
    if (Utils.checkIsNotNull(_customerRequestSingeton.filterData['dateFrom']) ||
        Utils.checkIsNotNull(_customerRequestSingeton.filterData['dateTo'])) {
      var dateFrom = Utils.convertTimeToSearch(
          _customerRequestSingeton.filterData['dateFrom']);
      var dateTo = Utils.convertTimeToSearch(
          _customerRequestSingeton.filterData['dateTo']);
      _customerRequestSingeton.filter += checkNUllFilter(
              _customerRequestSingeton.filter) +
          '"createDate": {"type": "${FilterType.IN_RANGE}", "dateFrom": "$dateFrom","dateTo": "$dateTo","filterType": "${FilterType.DATE}"}';
    }
    if (Utils.checkIsNotNull(stringQuery)) {
      _customerRequestSingeton.filter +=
          checkNUllFilter(_customerRequestSingeton.filter) +
              '"ftsValue":{"type":"contains","filter":"' +
              stringQuery +
              '","filterType":"text"}';
    }
    // this._customerRequestSingeton.filter +=
    //     '"createDate": {"type": "${FilterType.IN_RANGE}", "dateFrom": "${dateFrom}","dateTo": "${dateTo}","filterType": "${FilterType.DATE}"}';
  }

  tblStatus() {
    return {
      'OPEN': S.of(context).STATUS_CODE_OPEN,
      'IN_PROGRESS': S.of(context).STATUS_CODE_IN_PROGRESS,
      'ASSIGNED': S.of(context).STATUS_CODE_ASSIGNED,
      'OPNEED_MORE_INFOEN': S.of(context).STATUS_CODE_NEED_MORE_INFO,
      'REJECTED': S.of(context).STATUS_CODE_REJECTED,
      'DONE': S.of(context).STATUS_CODE_DONE,
      'NEED_MORE_INFO': S.of(context).STATUS_CODE_NEED_MORE_INFO
    };
  }

  getStatusNameByCode(code) {
    var tblStatusCode = tblStatus();
    var name = tblStatusCode[code];
    if (Utils.checkIsNotNull(name)) {
      return tblStatusCode[code];
    }
    return code;
  }

  Future<void> handleFetchData() async {
    buildFiltter();
    try {
      final Response response = await this
          ._customerRequestService
          .getPagingList(_customerRequestSingeton.currentPage, '',
              _customerRequestSingeton.filter);

      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
          _enablePullUp = false;
        } else {
          _customerRequestSingeton.currentPage =
              _customerRequestSingeton.currentPage + 1;
        }
        for (var data in lstData) {
          _customerRequestSingeton.getLstRequestModel
              .add(RequestModel.fromJson(data));
        }
      }
    } catch (e) {
    } finally {
      setState(() {
        if (isFirstEnter == true) {
          isFirstEnter = false;
        }
      });
    }
  }

  void _onLoading() async {
    try {
      if (mounted) {
        await handleFetchData();
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Widget buildTitle(BuildContext contexti) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Text(S.of(context).list_request),
      ),
    );
  }

  void goDetail(BuildContext context, RequestModel detail) async {
    // var   aggId= "20200616102843";
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomerRequestEditScreen(requestModel: detail),
      ),
    );
    if (result == true) {
      _customerRequestSingeton.currentPage = 1;
      _customerRequestSingeton.lstRequestModel = [];
      await handleFetchData();
      // handleFetchData();
    }
  }

  Widget searchItem() {
    return Container(
        child: InkWell(
            child: Stack(children: <Widget>[
      new Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(50.0),
              bottomRight: const Radius.circular(50.0)),
          gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // colors: [AppColor.appBarCenter, AppColor.appBarBottom],
              colors: [AppColor.appBar, AppColor.appBar]),
        ),
        height: 55,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
          child: Container(
              height: 65,
              decoration: CustomDecorations().baseDecoration(
                  Colors.black12, 20.0, 5.0, Colors.white, 20.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      // scrollPadding: const EdgeInsets.all(30.0),
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          stringQuery = value;
                        });

                        _onRefresh();

                        // filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        // suffixIcon: Icon(
                        //   Icons.clear,
                        // ),
                        border: InputBorder.none,
                        hintText: S.of(context).search,
                      ),
                      // decoration: InputDecoration(
                      //   disabledBorder: InputBorder.none,
                      //   hintText: S.of(context).search,
                      //   prefixIcon: Icon(Icons.search),
                      // ),
                    ),
                  )))),
    ])));
  }

  Widget buildItemListView(int i) {
    RequestModel detail = _customerRequestSingeton.getLstRequestModel[i];
    // if (i == 0) {
    //   return Column(children: [
    //   searchItem();
    // }
    return Column(children: [
      if (i == 0) searchItem(),
      Padding(
          padding: EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 0.0),
          child: Column(children: [
            Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  InkWell(
                    onTap: () {
                      goDetail(context, detail);
                      // Utils.pushName(null, RouteList.CUSTOMER_COMPLAIN_DETAIL_SCREEN,
                      //     params: detail);
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: CircleAvatar(
                        child: Text(
                            Utils.checkIsNotNull(detail.statusCode)
                                ? detail.statusCode![0]
                                : 'I',
                            style: TextStyle(color: AppColor.white)),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      // title: Text(
                      //   detail?.categoryName ?? '',
                      //   style: TextStyle(fontWeight: FontWeight.w500),
                      // ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.code_rounded,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    detail.issueCode ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),

                            new SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.collections,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    getStatusNameByCode(detail.statusCode) ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            new SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment_ind_rounded,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    detail.assignee ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            new SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.subtitles,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    detail.issueName ?? '',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black54),
                                  ),
                                )
                              ],
                            ),
                            // Text(
                            //   detail?.issueName ?? '',
                            //   style: TextStyle(
                            //       fontSize: 12.0, color: Colors.black54),
                            // ),
                            new SizedBox(height: 4.0),

                            Row(
                              children: [
                                Icon(
                                  Icons.date_range_rounded,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                      Utils.convertTime(detail?.makerDate ??
                                          DateTime.now().millisecondsSinceEpoch) ?? '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: AppColor.blackOpacity06)),
                                )
                              ],
                            ),

                            new SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    detail.makerId ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            new SizedBox(height: 4.0),
                          ]),
                      // trailing: IconButton(
                      //     onPressed: () async => {buildActionSheet(detail)},
                      //     icon: Icon(Icons.expand_more,
                      //         color: Theme.of(context).primaryColor))
                    ),
                  ),
                ]))
          ]))
    ]);
  }

  buildActionSheet(RequestModel item) async {
    // if (item.phoneNumber != null) {
    //   final result = await showModalActionSheet<String>(
    //     context: context,
    //     actions: [
    //       SheetAction(
    //         icon: Icons.call,
    //         label: S.of(context).call,
    //         key: ActionPhone.CALL,
    //       ),
    //       SheetAction(
    //         icon: Icons.sms,
    //         label: S.of(context).SMS,
    //         key: ActionPhone.SMS,
    //       ),
    //       SheetAction(
    //           icon: Icons.cancel,
    //           label: S.of(context).cancel,
    //           key: ActionPhone.CANCEL,
    //           isDestructiveAction: true),
    //     ],
    //   );
    //   if (result == ActionPhone.CALL) {
    //     Utils.actionPhone(item.phoneNumber, ActionPhone.CALL);
    //   } else if (result == ActionPhone.SMS) {
    //     Utils.actionPhone(item.phoneNumber, ActionPhone.SMS);
    //   }
    //   return;
    // }
    // return WidgetCommon.generateDialogOKGet(
    //     content: S.of(context).customerNoPhone);
  }

  navigateAndDisplaySelection(BuildContext context) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FilterCollectionScreen(),
    //   ),
    // );

    await NavigationService.instance.navigateToRoute(MaterialPageRoute(
      builder: (context) => FilterCollectionScreen(),
    ));
  }

  _navigateFiltter(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
        builder: (context) => FilterrequestScreen(),
      ),
    );

    if (result == true) {
      _customerRequestSingeton.currentPage = 1;
      _customerRequestSingeton.lstRequestModel = [];
      await handleFetchData();
    }
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
        builder: (context) => CustomerRequestScreen(),
      ),
    );

    if (result == true) {
      _customerRequestSingeton.currentPage = 1;
      _customerRequestSingeton.lstRequestModel = [];
      await handleFetchData();
    }
  }

  // _CustomerComplaintListScreenState() {
  //   searchBar = search_bar_package.SearchBar(
  //     setState: setState,
  //     onSubmitted: onSubmitted,
  //     buildDefaultAppBar: buildAppBar,
  //     clearOnSubmit: false,
  //     closeOnSubmit: false,
  //     hintText: S.of(context).search,
  //     onClosed: () {},
  //     onCleared: () {
  //       setState(() {
  //         stringQuery = '';
  //       });
  //     },
  //   );
  // }
  // AppBar buildAppBar(BuildContext context) {
  //   return new AppBar(
  //       flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
  //       backgroundColor: AppColor.appBar,
  //       title: new Text(S.of(context).my_request),
  //       actions: [searchBar.getSearchAction(context)]);
  // }

  void onSubmitted(String value) {
    setState(() {
      stringQuery = value;
    });
  }

  Widget buildBody() {
    return new NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          silverBar(),
        ];
      },
      body: Scrollbar(child: buildBodyView()),
    );
  }

  Widget silverBar() {
    return new SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      // expandedHeight: 120.0,
      pinned: true,
      title:
          Text(S.of(context).my_request, style: TextStyle(color: Colors.white)),
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.none,
          centerTitle: true,
          background: Stack(children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColor.appBarTop, AppColor.appBarCenter],
                ),
              ),
              // height: 180,
            ),
            // Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Icon(
            //       Icons.send_sharp,
            //       size: 120,
            //       color: Colors.white24,
            //     ))
          ])),
      actions: <Widget>[
        new Padding(
          padding: EdgeInsets.all(5.0),
          child: IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              _navigateFiltter(context);
              // Utils.pushName(null, RouteList.SEARCH_SCREEN);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: searchBar.build(context),
      // appBar: AppBarCommon(
      //   title: S.of(context).my_request,
      //   lstWidget: [],
      // ),
      // floatingActionButton: FloatContainerHomeScreen(),

      // body: Scrollbar(child: buildBodyView()),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.appBar,
          onPressed: () async {
            // goDetailtemp(context);
            _navigateAndDisplaySelection(context);
          },
          child: Icon(
            Icons.add,
            color: AppColor.white,
          )),
    );
  }

  Widget buildBodyView() {
    if (isFirstEnter) {
      return ShimmerCheckIn(
        height: 60.0,
        countLoop: 8,
      );
    }
    if (_customerRequestSingeton.getLstRequestModel.length == 0) {
      return Column(children: [
        // silverBar(),
        searchItem(),
        NoDataWidget()
      ]);
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      footer: CustomFooter(
        builder: (context, status) {
          Widget body;
          if (status == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (status == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (status == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (status == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (c, i) => buildItemListView(i),
        itemCount: _customerRequestSingeton.getLstRequestModel.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _customerRequestSingeton.clearData();
    // _customerRequestSingeton.currentPage = 1;
    // _customerRequestSingeton.lstRequestModel = [];
  }
}
