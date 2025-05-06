import 'package:flutter/widgets.dart';
import 'package:athena/common/constants/contract_type_list.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/employee/employee.hierachy.model.dart';
import 'package:athena/models/filter/dateFilter.model.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';

class FilterCollectionsProvider with ChangeNotifier {
  DateTime? meetingDate;
  DateTime? createdDate;
  DateTime? lastUpdatedDate;
  DateTime? assignDate;
  CheckInModel? checkInModel;
  StatusTicketModel? statusTicketModel;
  PTPModel? ptpModel;
  PaidCaseModel? paidCaseModel;
  SeftModel? seftModel;
  EmployeeHierachyModel? employeeHierachyModel;
  RecordStatusModel? recordStatusModel;
  TextEditingController addressCtr = new TextEditingController();
  TextEditingController customerNameCtr = new TextEditingController();
  TextEditingController bucketCtr = new TextEditingController();
  TextEditingController contractAppIdCtr = new TextEditingController();
  TextEditingController contractApplIdCtr = new TextEditingController();
  TextEditingController applicationCtr = new TextEditingController();
  TextEditingController idCardNumberCtrl = new TextEditingController();
  List<DateFilterModel> lstDateFilterModel = [];
  List<EmployeeHierachyModel> lstEmployeeHierachyModel = [];
  List<String> aggids = [];
  ContractTypeInfo? contractTypeInfo;

  List<ContractTypeInfo> contractTypeInfoConst = [];

  void initDateFilter() {
    if (lstDateFilterModel.length > 0) {
      return;
    }
    lstDateFilterModel.add(new DateFilterModel("Any", -1));
    lstDateFilterModel.add(new DateFilterModel("Today", 0));
    lstDateFilterModel.add(new DateFilterModel("Yesterday", 1));
    lstDateFilterModel.add(new DateFilterModel("This week", 2));
    lstDateFilterModel.add(new DateFilterModel("This month", 3));
    lstDateFilterModel.add(new DateFilterModel("This year", 4));
    lstDateFilterModel.add(new DateFilterModel("Custom", 5));
  }

  void clearData() {
    lstEmployeeHierachyModel = [];
    meetingDate = null;
    createdDate = null;
    contractTypeInfo = null;
    lastUpdatedDate = null;
    checkInModel = null;
    statusTicketModel = null;
    assignDate = null;
    ptpModel = null;
    paidCaseModel = null;
    seftModel = null;
    employeeHierachyModel = null;
    customerNameCtr.text = '';
    contractAppIdCtr.text = '';
    applicationCtr.text = '';
    contractApplIdCtr.text = '';
    idCardNumberCtrl.text = '';
    idCardNumberCtrl.text = '';
    addressCtr.text = '';
    bucketCtr.text='';
    aggids = [];
  }
}
