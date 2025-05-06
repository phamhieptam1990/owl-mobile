import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/employee/employee.hierachy.model.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';
import 'package:athena/widgets/common/common.dart';

import 'filter-collections.screen.dart';
import 'hierarchy/hiearchy.provider.dart';

class FilterCollectionTeamScreen extends StatefulWidget {
  final String page;
  FilterCollectionTeamScreen({
    Key? key,
    required this.page,
  }) : super(key: key);
  @override
  _FilterCollectionTeamScreenState createState() =>
      _FilterCollectionTeamScreenState();
}

class _FilterCollectionTeamScreenState extends State<FilterCollectionTeamScreen>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'FilterCollectionTeamScreen');
  final GlobalKey<FormFieldState> _keyTeam =
      new GlobalKey<FormFieldState>(debugLabel: '_keyTeam1');
  final filterCollectionProvider = getIt<FilterCollectionsProvider>();
  List<SeftModel> lstSeftModel = [];
  bool isSearching = false;
  final TextEditingController _keywordController = new TextEditingController();
  final _userInfoStore = getIt<UserInfoStore>();
  final _hiearchyProvider = getIt<HiearchyProvider>();
  SeftModel? _seft;
  int empId = -1;
  bool isUH = false;
  @override
  initState() {
    super.initState();
    initCheckIn();
    this._hiearchyProvider.clearData();
    this.filterCollectionProvider.lstEmployeeHierachyModel = [];
    _seft = this.filterCollectionProvider.seftModel ??  new SeftModel("TEAM", 1);
  }

  initCheckIn() {
    lstSeftModel.add(new SeftModel("SEFT", 0));
    lstSeftModel.add(new SeftModel("TEAM", 1));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      final user = this._userInfoStore.user?.moreInfo;
      if (user != null && Utils.checkIsNotNull(user)) {
        if (Utils.checkValueIsDouble(user['empId'])) {
          this._hiearchyProvider.empId = user['empId'].toInt();
        } else {
          this._hiearchyProvider.empId = user['empId'];
        }
        final roles = this._userInfoStore.user?.authorities ?? [];
        if (roles.isNotEmpty) {
          for (var role in roles) {
            String? authority = role.authority ?? '';
            if (authority == Roles.FCH) {
              isUH = true;
            }
          }
        }
      }
      empId = this._hiearchyProvider.empId;
      if (this._hiearchyProvider.lstHiearchy.length == 0) {
        this._hiearchyProvider.empDataLV1 = new EmpLVData(true, 0);
        await handleFetchData(
            this._hiearchyProvider.empId,
            this._hiearchyProvider.lstHiearchy,
            this._hiearchyProvider.empDataLV1,
            checkRole: true);
      } else {}
    } catch (e) {
      setState(() {});
    }
  }

  String? showFullName(EmployeeHierachyModel? hiearchyLV1) {
    if (hiearchyLV1 == null) return 'Nhân viên';
    final fullName = hiearchyLV1.fullName;
    if (Utils.checkIsNotNull(fullName)) {
      return fullName;
    }
    return 'Nhân viên';
  }

  String showDetail(EmployeeHierachyModel? hiearchyLV1) {
    if (hiearchyLV1 == null) return '';
    final empCode = hiearchyLV1.empCode;
    final workEmail = hiearchyLV1.workEmail;
    if (Utils.checkIsNotNull(empCode) && Utils.checkIsNotNull(workEmail)) {
      return '$empCode - $workEmail';
    }
    return '';
  }

  Widget buildScreen() {
    try{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: this.widget.page == 'HOME',
          child: Listener(
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child: DropdownButtonFormField<SeftModel>(
              decoration: InputDecoration(
                filled: true,
                labelText: "Lọc theo",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              isExpanded: true,
              value: _seft,
              key: _keyTeam,
              hint: Text(S.of(context).select), // Not necessary for Option 1
              items: lstSeftModel.map((SeftModel value) {
                return new DropdownMenuItem<SeftModel>(
                  value: value,
                  child: new Text(value.title),
                );
              }).toList(),
              onChanged: (value) async {
                if (value == null) return;

                if (_seft == value) {
                  return;
                }
                _seft = value;
                filterCollectionProvider.seftModel = value;
                filterCollectionProvider.employeeHierachyModel = null;
                this._hiearchyProvider.clearData();
                if (value.value == 1) {
                  await handleFetchData(
                      this.empId,
                      this._hiearchyProvider.lstHiearchy,
                      this._hiearchyProvider.empDataLV1,
                      checkRole: true);
                } else {
                  setState(() {});
                }
              },
            ),
          ),
        ),
        Visibility(
          visible: _hiearchyProvider.lstHiearchy.isNotEmpty ,
          child: ListTile(
              title: Text(showFullName(_hiearchyProvider.hiearchyLV1) ?? ''),
              subtitle: buildSubtitle(_hiearchyProvider.hiearchyLV1),
              trailing: Icon(Icons.expand_more),
              onTap: () async {
                final result = await showBarModalBottomSheet(
                  expand: false,
                  context: context,
                  isDismissible: true,
                  bounce: false,
                  backgroundColor: AppColor.primary,
                  builder: (context) => widgetLstEmployee(
                      this._hiearchyProvider.lstHiearchy,
                      this.empId,
                      this._hiearchyProvider.empDataLV1,
                      checkRole: true),
                );
                if (Utils.checkIsNotNull(result)) {
                  this._hiearchyProvider.hiearchyLV1 = result;
                  this._hiearchyProvider.hiearchyLV2 = null;
                  this._hiearchyProvider.hiearchyLV3 = null;
                  this._hiearchyProvider.hiearchyLV4 = null;
                  this._hiearchyProvider.hiearchyLV5 = null;
                  this._hiearchyProvider.lstHiearchyLV2 = [];
                  this._hiearchyProvider.lstHiearchyLV3 = [];
                  this._hiearchyProvider.lstHiearchyLV4 = [];
                  this._hiearchyProvider.lstHiearchyLV5 = [];
                  this._hiearchyProvider.empDataLV2 = new EmpLVData(true, 0);
                  this._hiearchyProvider.empDataLV3 = new EmpLVData(true, 0);
                  this._hiearchyProvider.empDataLV4 = new EmpLVData(true, 0);
                  this._hiearchyProvider.empDataLV5 = new EmpLVData(true, 0);
                  await handleFetchData(
                      this._hiearchyProvider.hiearchyLV1?.id ?? -1,
                      this._hiearchyProvider.lstHiearchyLV2,
                      this._hiearchyProvider.empDataLV2);
                }
              }),
        ),
        Visibility(
          visible: _hiearchyProvider.lstHiearchyLV2.isNotEmpty ,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListTile(
                  title: Text(showFullName(_hiearchyProvider.hiearchyLV2) ?? ''),
                  subtitle: buildSubtitle(_hiearchyProvider.hiearchyLV2),
                  trailing: Icon(Icons.expand_more),
                  onTap: () async {
                    if (_hiearchyProvider.hiearchyLV1?.id == null) return;

                    final result = await showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      isDismissible: false,
                      bounce: false,
                      backgroundColor: AppColor.primary,
                      builder: (context) => widgetLstEmployee(
                          _hiearchyProvider.lstHiearchyLV2,
                          _hiearchyProvider.hiearchyLV1?.id ?? -1,
                          _hiearchyProvider.empDataLV2),
                    );
                    if (Utils.checkIsNotNull(result)) {
                      this._hiearchyProvider.hiearchyLV2 = result;
                      this._hiearchyProvider.hiearchyLV3 = null;
                      this._hiearchyProvider.hiearchyLV4 = null;
                      this._hiearchyProvider.hiearchyLV5 = null;
                      this._hiearchyProvider.lstHiearchyLV3 = [];
                      this._hiearchyProvider.lstHiearchyLV4 = [];
                      this._hiearchyProvider.lstHiearchyLV5 = [];
                      this._hiearchyProvider.empDataLV3 =
                          new EmpLVData(true, 0);
                      this._hiearchyProvider.empDataLV4 =
                          new EmpLVData(true, 0);
                      this._hiearchyProvider.empDataLV5 =
                          new EmpLVData(true, 0);
                      await handleFetchData(
                          this._hiearchyProvider.hiearchyLV2?.id ?? -1,
                          this._hiearchyProvider.lstHiearchyLV3,
                          this._hiearchyProvider.empDataLV3);
                    }
                  })),
        ),
        Visibility(
          visible: this._hiearchyProvider.lstHiearchyLV3.isNotEmpty,
          child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListTile(
                  title: Text(showFullName(this._hiearchyProvider.hiearchyLV3) ?? ''),
                  subtitle: buildSubtitle(this._hiearchyProvider.hiearchyLV3),
                  trailing: Icon(Icons.expand_more),
                  onTap: () async {
                    final result = await showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      isDismissible: false,
                      backgroundColor: AppColor.primary,
                      builder: (context) => widgetLstEmployee(
                          this._hiearchyProvider.lstHiearchyLV3,
                          this._hiearchyProvider.hiearchyLV2?.id ?? -1,
                          this._hiearchyProvider.empDataLV3),
                    );
                    if (Utils.checkIsNotNull(result)) {
                      this._hiearchyProvider.hiearchyLV3 = result;
                      this._hiearchyProvider.hiearchyLV4 = null;
                      this._hiearchyProvider.hiearchyLV5 = null;
                      this._hiearchyProvider.lstHiearchyLV4 = [];
                      this._hiearchyProvider.lstHiearchyLV5 = [];
                      this._hiearchyProvider.empDataLV4 =
                          new EmpLVData(true, 0);
                      this._hiearchyProvider.empDataLV5 =
                          new EmpLVData(true, 0);
                      await handleFetchData(
                          this._hiearchyProvider.hiearchyLV3?.id ?? -1,
                          this._hiearchyProvider.lstHiearchyLV4,
                          this._hiearchyProvider.empDataLV4);
                    }
                  })),
        ),
        Visibility(
          visible: _hiearchyProvider.lstHiearchyLV4.isNotEmpty ,
          child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: ListTile(
                  title: Text(showFullName(this._hiearchyProvider.hiearchyLV4) ?? ''),
                  subtitle: buildSubtitle(this._hiearchyProvider.hiearchyLV4),
                  trailing: Icon(Icons.expand_more),
                  onTap: () async {
                    if (_hiearchyProvider.hiearchyLV3?.id == null) return;

                    final result = await showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      isDismissible: false,
                      bounce: false,
                      backgroundColor: AppColor.primary,
                      builder: (context) => widgetLstEmployee(
                          this._hiearchyProvider.lstHiearchyLV4,
                          this._hiearchyProvider.hiearchyLV3?.id ?? -1,
                          this._hiearchyProvider.empDataLV4),
                    );
                    if (Utils.checkIsNotNull(result)) {
                      this._hiearchyProvider.hiearchyLV4 = result;
                      this._hiearchyProvider.hiearchyLV5 = null;
                      this._hiearchyProvider.lstHiearchyLV5 = [];
                      this._hiearchyProvider.empDataLV5 =
                          new EmpLVData(true, 0);
                      await handleFetchData(
                          this._hiearchyProvider.hiearchyLV4?.id ?? -1,
                          this._hiearchyProvider.lstHiearchyLV5,
                          this._hiearchyProvider.empDataLV5);
                    }
                  })),
        ),
        Visibility(
          visible: _hiearchyProvider.lstHiearchyLV5.isNotEmpty ,
          child: Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: ListTile(
                  title: Text(showFullName(_hiearchyProvider.hiearchyLV5) ?? ''),
                  subtitle: buildSubtitle(_hiearchyProvider.hiearchyLV5),
                  trailing: Icon(Icons.expand_more),
                  onTap: () async {
                    if (_hiearchyProvider.hiearchyLV4?.id == null) return;
                    final result = await showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      isDismissible: false,
                      bounce: false,
                      backgroundColor: AppColor.primary,
                      builder: (context) => widgetLstEmployee(
                          _hiearchyProvider.lstHiearchyLV5,
                          _hiearchyProvider.hiearchyLV4?.id ?? -1,
                          _hiearchyProvider.empDataLV5),
                    );
                    if (result != null && Utils.checkIsNotNull(result)) {
                      this._hiearchyProvider.hiearchyLV5 = result;
                      setState(() {});
                    }
                  })),
        ),
      ],
    );}catch (e) {
      return Container();
    }
  }

  Future<void> handleFetchData(
      int empId, List<EmployeeHierachyModel> lst, EmpLVData empLVData,
      {bool checkRole = false}) async {
    try {
      WidgetCommon.showLoading();
      _hiearchyProvider.enablePullUp = true;
      Response response = await this
          ._hiearchyProvider
          .pivotPaging(empLVData.offsetLV, _hiearchyProvider.keyword, empId);
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (checkRole && isUH) {
          for (var data in lstData) {
            EmployeeHierachyModel emp = EmployeeHierachyModel.fromJson(data);
            if (Utils.checkIsNotNull(emp.empCode)) {
              if (emp.empCode?.indexOf('FC') == -1) {
                lst.add(EmployeeHierachyModel.fromJson(data));
              }
            }
          }
          empLVData.pullUpLV = false;
          // nếu là UH chỉ lấy TL
        } else {
          if (lstData.length < APP_CONFIG.LIMIT_QUERY_50) {
            empLVData.pullUpLV = false;
          } else {
            empLVData.offsetLV = Utils.buildOffset(empLVData.offsetLV,
                limit: APP_CONFIG.LIMIT_QUERY_50);
          }
          for (var data in lstData) {
            lst.add(EmployeeHierachyModel.fromJson(data));
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {});
      WidgetCommon.dismissLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCommon(title: S.of(context).filter, lstWidget: []),
        body: Container(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: buildScreen(),
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(callbackOK: () async {
          filterCollectionProvider.seftModel = _seft;
          EmployeeHierachyModel? model = this._hiearchyProvider.hiearchyLV5;
          if (model == null && !Utils.checkIsNotNull(model)) {
            model = this._hiearchyProvider.hiearchyLV4;
          }
          if (model == null && !Utils.checkIsNotNull(model)) {
            model = this._hiearchyProvider.hiearchyLV3;
          }
          if (model == null && !Utils.checkIsNotNull(model)) {
            model = this._hiearchyProvider.hiearchyLV2;
          }
          if (model == null && !Utils.checkIsNotNull(model)) {
            model = this._hiearchyProvider.hiearchyLV1;
          }
          if (Utils.checkIsNotNull(model)) {
            filterCollectionProvider.employeeHierachyModel = model;
          }
          if (filterCollectionProvider.seftModel?.value == 1 &&
              filterCollectionProvider.employeeHierachyModel == null) {
            // Fix 59: Add void return for async function
            WidgetCommon.showSnackbar(
                _scaffoldKey, 'Vui lòng chọn nhân viên cấp dưới');
            return;
          }
          if (this.widget.page == 'HOME') {
            Utils.pushName(context, RouteList.COLLECTION_SCREEN, params: '');
          } else {
            Navigator.pop(context, model);
          }
        }, callbackCancel: () async {
          if (this.widget.page == 'HOME') {
            filterCollectionProvider.clearData();
          }
          _keywordController.text = '';
          this._hiearchyProvider.clearData();
          WidgetCommon.resetGlobalFormFieldState(_keyTeam);
          await handleFetchData(empId, this._hiearchyProvider.lstHiearchy,
              this._hiearchyProvider.empDataLV1,
              checkRole: true);
        }));
  }

  bool showEmployee() {
    return filterCollectionProvider.seftModel?.value == 1;
  }

  Widget widgetLstEmployee(
      List<EmployeeHierachyModel> lst, int empId, EmpLVData empLVData,
      {bool checkRole = false}) {
    return Material(
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                backgroundColor: AppColor.primary,
                leading: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                ),
                middle: Text(
                  'Danh sách nhân viên cấp dưới',
                  style: TextStyle(color: Colors.white),
                )),
            child: EmployeeModalInside(
                lst: lst,
                hiearchyProvider: _hiearchyProvider,
                empId: empId,
                empLVData: empLVData,
                checkRole: checkRole))
        // child: Container(
        //   height: AppState.getHeightDevice(context) * 0.8,
        //   child: buildBodyView(lst, empId, empLVData),
        // )),
        );
  }

  Widget buildSubtitle(EmployeeHierachyModel? emp) {
    if (emp == null) return const SizedBox();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(height: 4.0),
          Text(
            showDetail(emp),
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Divider(
            color: AppColor.blackOpacity,
          ),
        ]);
  }

  @override
  void dispose() {
    if (this.widget.page == 'HOME') {
      filterCollectionProvider.seftModel = null;
      filterCollectionProvider.employeeHierachyModel = null;
    }
    WidgetCommon.dismissLoading();
    WidgetCommon.disposeGlobalFormFieldState(_keyTeam);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class EmployeeModalInside extends StatefulWidget {
  List<EmployeeHierachyModel> lst;
  HiearchyProvider hiearchyProvider;
  int empId;
  EmpLVData empLVData;
  bool checkRole;
  EmployeeModalInside(
      {Key? key,
      required this.lst,
      required this.hiearchyProvider,
      required this.empId,
      required this.empLVData,
      required this.checkRole})
      : super(key: key);
  @override
  _EmployeeModalInsideState createState() => _EmployeeModalInsideState();
}

class _EmployeeModalInsideState extends State<EmployeeModalInside> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onLoading(
      List<EmployeeHierachyModel> lst, int empId, EmpLVData empLVData) async {
    try {
      if (mounted) {
        await handleFetchData(empId, lst, empLVData);
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppState.getHeightDevice(context) * 0.8,
      child: buildBodyView(widget.lst, widget.empId, widget.empLVData),
    );
  }

  Future<void> handleFetchData(
      int empId, List<EmployeeHierachyModel> lst, EmpLVData empLVData) async {
    try {
      WidgetCommon.showLoading();
      widget.hiearchyProvider.enablePullUp = true;
      Response response = await this.widget.hiearchyProvider.pivotPaging(
          empLVData.offsetLV, widget.hiearchyProvider.keyword, empId);

      if (Utils.checkRequestIsComplete(response)) {
        final lstData = Utils.handleRequestData2Level(response);
        if (lstData.length < APP_CONFIG.LIMIT_QUERY_50) {
          empLVData.pullUpLV = false;
        } else {
          empLVData.offsetLV = Utils.buildOffset(empLVData.offsetLV,
              limit: APP_CONFIG.LIMIT_QUERY_50);
        }
        if (Utils.isArray(lstData)) {
          for (var data in lstData) {
            lst.add(EmployeeHierachyModel.fromJson(data));
          }
        }
      }
    } catch (e) {
    } finally {
      setState(() {});
      WidgetCommon.dismissLoading();
    }
  }

  Widget buildBodyView(
      List<EmployeeHierachyModel> lst, int empId, EmpLVData empLVData) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: empLVData.pullUpLV,
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
      onLoading: () {
        this._onLoading(lst, empId, empLVData);
      },
      child: ListView.builder(
        itemBuilder: (c, i) => buildEachItemListView(lst, i),
        itemCount: lst.length,
      ),
    );
  }

  Widget buildEachItemListView(List<EmployeeHierachyModel> lst, int index) {
    try {
      if (index >= lst.length) {
        return const SizedBox();
      }
      final EmployeeHierachyModel detail = lst[index];
      return InkWell(
        onTap: () {
          Navigator.pop(context, detail);
        },
        child: ListTile(
          contentPadding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
          title: Text(
            detail.fullName ?? '',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new SizedBox(height: 4.0),
                Text(
                  '${detail.empCode ?? ''} - ${detail.workEmail ?? ''}',
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
                Divider(
                  color: AppColor.blackOpacity,
                ),
              ]),
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}
