import 'package:after_layout/after_layout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:athena/common/constants/contract_type_list.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/widgets/common/common.dart';
import 'filter-collections-team.screen.dart';
// ignore: must_be_immutable

class FilterCollectionScreen extends StatefulWidget {
  FilterCollectionScreen({Key? key}) : super(key: key);
  @override
  _FilterCollectionScreenState createState() => _FilterCollectionScreenState();
}

class _FilterCollectionScreenState extends State<FilterCollectionScreen>
    with AfterLayoutMixin {
  final _categorySingeton = new CategorySingeton();

  final filterCollectionProvider = getIt<FilterCollectionsProvider>();
  bool isShowSeft = false;
  List<StatusTicketModel> lstStatusTicketModel = [];
  List<PTPModel> lstPTPModel = [];
  List<CheckInModel> lstCheckInModel = [];
  List<PaidCaseModel> lstPaidCaseModel = [];
  List<SeftModel> lstSeftModel = [];
  List<ContractTypeInfo> contractTypeInfoList = [];

  final _keyTeam = new GlobalKey<FormFieldState>(debugLabel: '_keyTeam');
  final GlobalKey<FormFieldState> _keyStatus =
      new GlobalKey<FormFieldState>(debugLabel: '_keyStatus');
  final GlobalKey<FormFieldState> _keyCheckIn =
      new GlobalKey<FormFieldState>(debugLabel: '_keyCheckIn');
  final GlobalKey<FormFieldState> _keyPTP =
      new GlobalKey<FormFieldState>(debugLabel: '_keyPTP');
  final GlobalKey<FormFieldState> _keyCase =
      new GlobalKey<FormFieldState>(debugLabel: '_keyCase');

  final GlobalKey<FormFieldState> _keyContractType =
      new GlobalKey<FormFieldState>(debugLabel: '_keyContractType');

  @override
  initState() {
    contractTypeInfoList = filterCollectionProvider.contractTypeInfoConst;
    super.initState();
  }

  initCheckIn() {
    lstCheckInModel.add(new CheckInModel(S.of(context).checkIn, 1));
    lstCheckInModel.add(new CheckInModel(S.of(context).notCheckIn, 0));
    lstCheckInModel.add(new CheckInModel(S.of(context).select, -1));
    lstPTPModel.add(new PTPModel(S.of(context).PTP, 1));
    lstPTPModel.add(new PTPModel(S.of(context).notPTP, 0));
    lstPTPModel.add(new PTPModel(S.of(context).select, -1));
    lstPaidCaseModel.add(new PaidCaseModel(S.of(context).paidCases, 1));
    lstPaidCaseModel.add(new PaidCaseModel(S.of(context).unpaidCases, 0));
    lstPaidCaseModel.add(new PaidCaseModel(S.of(context).select, -1));
    lstSeftModel.add(new SeftModel("SEFT", 0));
    lstSeftModel.add(new SeftModel("TEAM", 1));
    // lstRecordStatus.add(new SeftModel("Hủy", "C"));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      initCheckIn();
      await getContractTypeInfoList();
      await _categorySingeton.initAllCateogyData();
      if (_categorySingeton.lstStatusTicketModel.length > 0) {
        for (StatusTicketModel data in _categorySingeton.lstStatusTicketModel) {
          lstStatusTicketModel.add(data);
        }
      }
 

      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> getContractTypeInfoList() async {
    try {
      if ((contractTypeInfoList.isNotEmpty ?? false)) return;
      final response = await CollectionService().getContractTypeInfoList();
      final contractTypeInfoResponse =
          ContractTypeInfoListResponse.fromJson(response.data);
      filterCollectionProvider.contractTypeInfoConst =
          contractTypeInfoResponse.data ?? [];
      setState(() {
        contractTypeInfoList =
            filterCollectionProvider.contractTypeInfoConst ?? [];
      });
    } catch (_) {
      debugPrint(_.toString());
    }
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          controller: filterCollectionProvider.addressCtr,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: S.of(context).address),
        ),
        TextFormField(
          controller: filterCollectionProvider.customerNameCtr,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: S.of(context).FullName),
        ),
          TextFormField(
          controller: filterCollectionProvider.bucketCtr,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: "Bucket đầu kỳ"),
        ),
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                onChanged: (date) {}, onConfirm: (date) {
              filterCollectionProvider.createdDate = date;
              setState(() {});
            }, locale: LocaleType.vi);
          },
          child: ListTile(
            title: Text(S.of(context).createdDate),
            subtitle: Text((filterCollectionProvider.createdDate == null)
                ? " "
                : Utils.convertTimeWithoutTime(filterCollectionProvider
                    .createdDate?.millisecondsSinceEpoch)),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
        Divider(
          height: 0.0,
          thickness: 1.0,
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButtonFormField<SeftModel>(
            decoration: InputDecoration(
              filled: true,
              labelText: "Lọc theo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            key: _keyTeam,
            isExpanded: true,
            value: filterCollectionProvider.seftModel,
            hint: Text(S.of(context).select), // Not necessary for Option 1
            items: lstSeftModel.map((SeftModel value) {
              return new DropdownMenuItem<SeftModel>(
                value: value,
                child: new Text(value.title),
              );
            }).toList(),
            onChanged: (_) {
              filterCollectionProvider.seftModel = _;
              filterCollectionProvider.employeeHierachyModel = null;
              isShowSeft = showEmployee();
              setState(() {});
            },
          ),
        ),
        Visibility(
            visible: (filterCollectionProvider.employeeHierachyModel != null ||
                isShowSeft == true),
            child: InkWell(
              onTap: () async {
                final result = await NavigationService.instance
                    .navigateToRoute(MaterialPageRoute(
                  builder: (context) =>
                      FilterCollectionTeamScreen(page: 'FILTER_COLLECTION'),
                ));
                if (result != null) {
                  filterCollectionProvider.employeeHierachyModel = result;
                  setState(() {});
                }
              },
              child: ListTile(
                title: Text(S.of(context).Employee),
                subtitle: Text(getEmpCode(), maxLines: 2),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            )),
        Divider(
          height: 0.0,
          thickness: 1.0,
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButtonFormField<StatusTicketModel>(
            decoration: InputDecoration(
              filled: true,
              labelText: S.of(context).status,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            isExpanded: true,
            key: _keyStatus,
            // value: filterCollectionProvider.statusTicketModel,
            hint: Text(S.of(context).select), // Not necessary for Option 1
            items: lstStatusTicketModel.map((StatusTicketModel value) {
              return new DropdownMenuItem<StatusTicketModel>(
                value: value,
                child: new Text(value.actionGroupName ?? ''),
              );
            }).toList(),
            onChanged: (_) {
              filterCollectionProvider.statusTicketModel = _;
            },
          ),
        ),
        TextFormField(
          controller: filterCollectionProvider.contractApplIdCtr,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.all(8.0),
              labelText: S.of(context).contractNumber + " (APPL_ID)"),
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButtonFormField<CheckInModel>(
            decoration: InputDecoration(
              filled: true,
              labelText:
                  S.of(context).checkIn + " / " + S.of(context).notCheckIn,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            isExpanded: true,
            key: _keyCheckIn,
            value: filterCollectionProvider.checkInModel,
            hint: Text(S.of(context).select), // Not necessary for Option 1
            items: lstCheckInModel.map((CheckInModel value) {
              return new DropdownMenuItem<CheckInModel>(
                value: value,
                child: new Text(value.title),
              );
            }).toList(),
            onChanged: (_) {
              filterCollectionProvider.checkInModel = _;
            },
          ),
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButtonFormField<PTPModel>(
            decoration: InputDecoration(
              filled: true,
              labelText: S.of(context).PTP + " /" + S.of(context).notPTP,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            isExpanded: true,
            key: _keyPTP,
            value: filterCollectionProvider.ptpModel,
            hint: Text(S.of(context).select), // Not necessary for Option 1
            items: lstPTPModel.map((PTPModel value) {
              return new DropdownMenuItem<PTPModel>(
                value: value,
                child: new Text(value.title),
              );
            }).toList(),
            onChanged: (_) {
              filterCollectionProvider.ptpModel = _;
            },
          ),
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButtonFormField<PaidCaseModel>(
            decoration: InputDecoration(
              filled: true,
              labelText:
                  S.of(context).paidCases + " /" + S.of(context).unpaidCases,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            isExpanded: true,
            key: _keyCase,
            value: filterCollectionProvider.paidCaseModel,
            hint: Text(S.of(context).select), // Not necessary for Option 1
            items: lstPaidCaseModel.map((PaidCaseModel value) {
              return new DropdownMenuItem<PaidCaseModel>(
                value: value,
                child: new Text(value.title),
              );
            }).toList(),
            onChanged: (_) {
              filterCollectionProvider.paidCaseModel = _;
            },
          ),
        ),
        // InkWell(
        //   onTap: () {
        //     DatePicker.showDatePicker(context,
        //         showTitleActions: true,
        //         onChanged: (date) {}, onConfirm: (date) {
        //       filterCollectionProvider.assignDate = date;
        //       setState(() {});
        //     }, locale: LocaleType.vi);
        //   },
        //   child: ListTile(
        //     title: Text(S.of(context).AssignedDate),
        //     subtitle: Text((filterCollectionProvider.assignDate == null)
        //         ? " "
        //         : Utils.convertTimeWithoutTime(filterCollectionProvider
        //             .assignDate.millisecondsSinceEpoch)),
        //     trailing: Icon(Icons.keyboard_arrow_right),
        //   ),
        // ),
        Divider(
          height: 0.0,
          thickness: 1.0,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 250.0),
          child: Container(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCommon(title: S.of(context).filter, lstWidget: []),
        body: SingleChildScrollView(
          child: buildScreen(),
          reverse: false,
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(callbackOK: () async {
          if (this.filterCollectionProvider.customerNameCtr.text.length > 0 ||
              this.filterCollectionProvider.addressCtr.text.length > 0) {
            this.filterCollectionProvider.paidCaseModel = null;
          }
          Navigator.pop(context, true);
        }, callbackCancel: () async {
          filterCollectionProvider.clearData();
          WidgetCommon.resetGlobalFormFieldState(_keyCheckIn);
          WidgetCommon.resetGlobalFormFieldState(_keyPTP);
          WidgetCommon.resetGlobalFormFieldState(_keyStatus);
          WidgetCommon.resetGlobalFormFieldState(_keyTeam);
          WidgetCommon.resetGlobalFormFieldState(_keyCase);
          WidgetCommon.resetGlobalFormFieldState(_keyContractType);
          // WidgetCommon.resetGlobalFormFieldState(_keyRecordStatus);
          setState(() {});
        }));
  }

   bool showEmployee() {
    // Fix 18: Remove redundant null check and simplify expression
    return filterCollectionProvider.seftModel?.value == 1;
  }

  String getEmpCode() {
    // Fix 19: Add null checks to avoid the error
    if (filterCollectionProvider.employeeHierachyModel == null) {
      return "";
    }
    
    final fullName = filterCollectionProvider.employeeHierachyModel?.fullName ?? '';
    final empCode = filterCollectionProvider.employeeHierachyModel?.empCode ?? '';
    return '$fullName - $empCode';
  }

  @override
  void dispose() {
    WidgetCommon.resetGlobalFormFieldState(_keyCheckIn);
    WidgetCommon.resetGlobalFormFieldState(_keyPTP);
    WidgetCommon.resetGlobalFormFieldState(_keyStatus);
    WidgetCommon.resetGlobalFormFieldState(_keyTeam);
    WidgetCommon.resetGlobalFormFieldState(_keyCase);
    WidgetCommon.resetGlobalFormFieldState(_keyContractType);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class CheckInModel extends Equatable {
  String title;
  int value;
  CheckInModel(this.title, this.value);

  @override
  List<Object> get props => [title, value];
}

class PTPModel extends Equatable {
  String title;
  int value;
  PTPModel(this.title, this.value);

  @override
  List<Object> get props => [title, value];
}

class PaidCaseModel extends Equatable {
  String title;
  int value;
  PaidCaseModel(this.title, this.value);

  @override
  List<Object> get props => [title, value];
}

class SeftModel extends Equatable {
  String title;
  int value;
  SeftModel(this.title, this.value);

  @override
  List<Object> get props => [title, value];
}

class SortModel {
  String title;
  String value;
  String key;
  SortModel(this.title, this.value, this.key);
}

class DislayModel {
  String title;
  String value;
  DislayModel(this.title, this.value);
}

class RecordStatusModel extends Equatable {
  String title;
  String value;
  RecordStatusModel(this.title, this.value);
  @override
  List<Object> get props => [title, value];
}
