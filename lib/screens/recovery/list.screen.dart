import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/recovery/recovery.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/recovery/recovery.provider.dart';
import 'package:athena/screens/recovery/widget/listTile.widget.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/debouncer.dart';
import 'package:athena/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'detail.screen.dart';

class ListRecoveryScreen extends StatefulWidget {
  ListRecoveryScreen({Key? key}) : super(key: key);
  @override
  _ListRecoveryScreenState createState() => _ListRecoveryScreenState();
}

class _ListRecoveryScreenState extends State<ListRecoveryScreen>
    with AfterLayoutMixin {
  final _recoveryProvider = getIt<RecoveryProvider>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<RecoveryModel> lstRecoveryModelTemp = [];
  bool _enablePullUp = true;
  bool isSearch = false;
  bool isFirstEnter = true;
  String title = '';
  TextEditingController _searchQueryController = new TextEditingController();
  String lastKeywordSearch = '';
  final _debouncer = Debouncer();
  @override
  initState() {
    super.initState();
    _searchQueryController.addListener(onSearchChanged);
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  Future<void> onSearchChanged() async {
    _debouncer(() async {
      String text = _searchQueryController.text.toString();
      if (text.length <= 2) {
        return;
      }
      if (lastKeywordSearch != text) {
        lastKeywordSearch = text;
        await updateSearchQuery(text, hideKeyBoard: false);
      }
    });
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQueryController,
      textInputAction: TextInputAction.search,
      autofocus: false,
      style: TextStyle(color: AppColor.white),
      decoration: const InputDecoration(
        hintText: "Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ",
        hintStyle: const TextStyle(color: Colors.white60),
      ),
      onSubmitted: updateSearchQuery,
    );
  }

  Future<void> updateSearchQuery(String newQuery,
      {bool hideKeyBoard = true}) async {
    if (hideKeyBoard) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    if (Utils.checkIsNotNull(newQuery)) {
      if (_recoveryProvider.keyword == newQuery) {
        return;
      }
    }
    _recoveryProvider.keyword = newQuery;
    _recoveryProvider.currentPage = 0;
    _recoveryProvider.lstRecovery = [];
    isFirstEnter = true;
    setState(() {});
    await handleFetchData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    try {
      _recoveryProvider.currentPage = 0;
      _recoveryProvider.lstRecovery = [];
      this.isFirstEnter = true;
      setState(() {});
      await handleFetchData();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Future<void> handleFetchData() async {
    try {
      _enablePullUp = true;
      Response response;

      response = await this._recoveryProvider.pivotPaging(
          _recoveryProvider.currentPage, _recoveryProvider.keyword);
      countPaging();

      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
          _enablePullUp = false;
        } else {
          _recoveryProvider.currentPage += (APP_CONFIG.LIMIT_QUERY);
        }
        if (_recoveryProvider.lstRecovery.isEmpty) {
          for (var data in lstData) {
            _recoveryProvider.lstRecovery.add(RecoveryModel.fromJson(data));
          }
        } else {
          var data;
          for (int index = 0; index < lstData.length; index++) {
            data = lstData[index];
            if (index == 0) {
              if (data['applId'] ==
                  _recoveryProvider
                      .lstRecovery[_recoveryProvider.lstRecovery.length - 1]
                      .applId) {
                continue;
              }
            }
            _recoveryProvider.lstRecovery.add(RecoveryModel.fromJson(data));
          }
        }
      }
    } catch (e) {
      printLog(e);
    } finally {
      if (isFirstEnter == true) {
        isFirstEnter = false;
      }
      setState(() {});
    }
  }

  countPaging() {
    this
        ._recoveryProvider
        .pivotCount(_recoveryProvider.currentPage, _recoveryProvider.keyword)
        .then((responseCount) {
      handleDataCountPagingList(responseCount);
    });
  }

  handleDataCountPagingList(Response responseCount) {
    if (Utils.checkRequestIsComplete(responseCount)) {
      var responseData = responseCount.data;
      if (Utils.checkIsNotNull(responseData)) {
        this._recoveryProvider.totalLength = responseData['data'];
        if (!isFirstEnter) {
          setState(() {});
        }
      }
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
      onTap: () async {
        // await openSort();
      },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Text('Recovery ' +
            ' (' +
            _recoveryProvider.totalLength.toString() +
            ')'),
      ),
    );
  }

  Widget buildItemListView(int i) {
    final detail = _recoveryProvider.lstRecovery[i];
 // Ensure clientName isn't null
    final String clientName = detail.clientName ?? 'Chưa có';
    detail.clientName = clientName;
    final String firstChar = clientName.isNotEmpty ? clientName[0] : '?';
    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              NavigationService.instance.navigateToRoute(
                MaterialPageRoute(
                    builder: (context) =>
                        RecoveryDetailScreen(recoveryModel: detail)),
              );
            },
            child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: CircleAvatar(
                    child: Text(clientName,
                        style: TextStyle(color: AppColor.white)),
                    backgroundColor:
                        _recoveryProvider.isRecordNew(detail.type ?? '', context)),
                title: Text(
                  clientName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: LeadingTitleRecovery(recoveryModel: detail),
                trailing: InkWell(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    await this
                        ._recoveryProvider
                        .buildActionSheet(detail, context, _scaffoldKey);
                  },
                  child: Icon(Icons.expand_more),
                )),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
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
          title: isSearch ? _buildSearchField() : buildTitle(context),
          actions: <Widget>[
            IconButton(
              icon: isSearch ? Icon(Icons.close) : Icon(Icons.search),
              onPressed: () {
                isSearch = !isSearch;
                setState(() {});
              },
            ),
          ]),
      body: Scrollbar(child: buildBodyView()),
    );
  }

  Widget buildBodyView() {
    if (isFirstEnter) {
      return ShimmerCheckIn(
        height: 60.0,
        countLoop: 8,
      );
    }
    if (_recoveryProvider.lstRecovery.length == 0) {
      return NoDataWidget();
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      footer: CustomFooter(
        builder: (context, status) {
          Widget body;
          if (status == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (status == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (status == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (status == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
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
        itemCount: _recoveryProvider.lstRecovery.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetCommon.dismissLoading();
    _recoveryProvider.clearData();
    isSearch = false;
    _searchQueryController.removeListener(onSearchChanged);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
