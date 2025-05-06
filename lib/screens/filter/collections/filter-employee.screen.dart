import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/employee/employee.hierachy.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

class SearchEmployeeScreen extends StatefulWidget {
  @override
  _SearchEmployeeScreenState createState() => _SearchEmployeeScreenState();
}

class _SearchEmployeeScreenState extends State<SearchEmployeeScreen>
    with AfterLayoutMixin {
  bool isFirstEnter = true;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'SearchEmployeeScreen');
  final TextEditingController _keywordController = new TextEditingController();
  final filterCollectionProvider = getIt<FilterCollectionsProvider>();
  final _collectionService = new CollectionService();
  final _userInfoStore = getIt<UserInfoStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCommon(title: "Tìm theo nhân viên", lstWidget: []),
        body: Scrollbar(
          child: buildScreen(),
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(callbackOK: () async {
          Navigator.pop(context, true);
        }, callbackCancel: () async {
          setState(() {});
        }));
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _keywordController,
          validator: (val) => Utils.isRequire(context, val ?? ''),
          onFieldSubmitted: (term) async {
            if (term.isEmpty) {
              return;
            }
            if (term.length <= 1) {
              return;
            }
            handleSearch();
          },
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Tìm kiếm theo tên, số điện thoại",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Expanded(child: buildEventList())
      ],
    );
  }

  Widget buildEventList() {
    if (isFirstEnter) {
      return Container();
    }
    if (filterCollectionProvider.lstEmployeeHierachyModel.length == 0) {
      return NoDataWidget();
    }
    return ListView.builder(
      itemBuilder: (c, i) => buildItemListView(i),
      itemCount: filterCollectionProvider.lstEmployeeHierachyModel.length,
    );
  }

  Widget buildItemListView(int index) {
    EmployeeHierachyModel detail =
        this.filterCollectionProvider.lstEmployeeHierachyModel[index];
    return InkWell(
      onTap: () {
        Navigator.pop(context, detail);
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: CircleAvatar(
          child: Text(detail?.fullName.toString() ??'',
              style: TextStyle(color: AppColor.white)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          'Họ tên: ${detail.fullName ?? ''}',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(height: 4.0),
              Text(
                'Mã nhân viên: ${detail.empCode ?? ''}',
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
              Text(
                'Nhân viên QL: ${detail.reportFullName ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
              Divider(
                color: AppColor.blackOpacity,
              ),
            ]),
      ),
    );
  }

  Future<void> handleSearch() async {
    try {
      String empCodeParent = '';
      isFirstEnter = false;
      this.filterCollectionProvider.lstEmployeeHierachyModel = [];
      empCodeParent = _userInfoStore.user?.moreInfo?['empCode'];
          Response response = await _collectionService.getEmployee(
          this._keywordController.text.toString(), empCodeParent);
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData(response);
        if (Utils.isArray(lstData)) {
          for (var data in lstData) {
            this
                .filterCollectionProvider
                .lstEmployeeHierachyModel
                .add(EmployeeHierachyModel.fromJson(data));
          }
        }
      }
    } catch (e) {
    } finally {
      setState(() {});
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.filterCollectionProvider.lstEmployeeHierachyModel = [];
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
