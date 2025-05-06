import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/models/employee/employee.hierachy.model.dart';
import 'package:athena/utils/common/provider.common.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/utils.dart';
import 'hiearchy.constant.dart';

class HiearchyProvider extends ProviderCommon {
  int empId = -1;
  List<EmployeeHierachyModel> lstHiearchy = [];
  List<EmployeeHierachyModel> lstHiearchyLV2 = [];
  List<EmployeeHierachyModel> lstHiearchyLV3 = [];
  List<EmployeeHierachyModel> lstHiearchyLV4 = [];
  List<EmployeeHierachyModel> lstHiearchyLV5 = [];

  EmployeeHierachyModel? hiearchyLV1;
  EmployeeHierachyModel? hiearchyLV2;
  EmployeeHierachyModel? hiearchyLV3;
  EmployeeHierachyModel? hiearchyLV4;
  EmployeeHierachyModel? hiearchyLV5;

  EmpLVData empDataLV1 = EmpLVData(true, 0);
  EmpLVData empDataLV2 = EmpLVData(true, 0);
  EmpLVData empDataLV3 = EmpLVData(true, 0);
  EmpLVData empDataLV4 = EmpLVData(true, 0);
  EmpLVData empDataLV5 = EmpLVData(true, 0);

  Future<Response> pivotPaging(int offsetCurrent, String keyword, int empId) {
    Map<String, dynamic> params = {
        "startRow": offsetCurrent,
        "endRow":
            Utils.buildEndrow(offsetCurrent, limit: APP_CONFIG.LIMIT_QUERY_50),
        "rowGroupCols": [],
        "valueCols": [],
        "pivotCols": [],
        "pivotMode": false,
        "groupKeys": [],
        "filterModel": {
          "teamMembers": {
            "type": "IN",
            "values": [empId],
            "filterType": "set"
          },
          "recordStatus": {
            "type": "equals",
            "filter": "O",
            "filterType": "text"
          }
        },
        "sortModel": [
          {"colId": "fullName", "sort": "asc"}
        ]
    };
    return HttpHelper.postJSON(HiearchyConstant.PIVOT_PAGING, body: params);
  }

  @override
  clearData() {
    super.clearData();
    this.lstHiearchy = [];
    this.lstHiearchyLV2 = [];
    this.lstHiearchyLV3 = [];
    this.lstHiearchyLV4 = [];
    this.lstHiearchyLV5 = [];
    hiearchyLV1 = null;
    hiearchyLV2 = null;
    hiearchyLV3 = null;
    hiearchyLV4 = null;
    hiearchyLV5 = null;
    empDataLV1 = new EmpLVData(true, 0);
    empDataLV2 = new EmpLVData(true, 0);
    empDataLV3 = new EmpLVData(true, 0);
    empDataLV4 = new EmpLVData(true, 0);
    empDataLV5 = new EmpLVData(true, 0);
  }
}

class EmpLVData {
  bool pullUpLV;
  int offsetLV;
  EmpLVData(this.pullUpLV, this.offsetLV);
}
