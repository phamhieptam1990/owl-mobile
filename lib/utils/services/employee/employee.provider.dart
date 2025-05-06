import 'package:flutter/widgets.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/userInfo.model.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/utils.dart';

import '../../app_state.dart';

class EmployeeProvider with ChangeNotifier {
  List<EmployeeModel> lstEmployee = [];
  List<EmployeeModel> get getLstEmployee => lstEmployee;
  final userInfoStore = getIt<UserInfoStore>();
  final appState = new AppState();
  set setLstEmployee(List<EmployeeModel> lstEmployee) => this.lstEmployee = lstEmployee;
  void addEmployee(EmployeeModel emp) {
    lstEmployee.add(emp);
  }

  void addEmployees(List<EmployeeModel> emps) {
    lstEmployee.addAll(emps);
  }

  void addEmployeesTemp(var emps) {
    bool isAdd = true;
    for (var emp in emps) {
      isAdd = true;
      for (int i = 0; i < lstEmployee.length; i++) {
        if (lstEmployee[i].empCode == emp['empCode']) {
          lstEmployee[i] = EmployeeModel.fromJson(emp);
          isAdd = false;
          break;
        }
      }
      if (isAdd) {
        EmployeeModel _emp = EmployeeModel.fromJson(emp);
        lstEmployee.add(_emp);
      }
    }
    HiveDBService.addEmployees(lstEmployee);
  }

  void checkAddEmployee(EmployeeModel emp) {
    try {
      if (lstEmployee.isEmpty) {
        if (Utils.checkIsNotNull(this.userInfoStore.user)) {
          UserInfoModel user = this.userInfoStore.user!;
          final userProfile = this.appState.getMoreInfoUserInfoStore();
          if (Utils.checkIsNotNull(userProfile)) {
            final fcCode = userProfile['empCode'];
            if (fcCode == emp.empCode) {
              emp.fullName = user.fullName;
              lstEmployee.add(emp);
              return;
            }
          }
          lstEmployee.add(emp);
        } else {
          bool isAdd = true;
          for (EmployeeModel empTemp in lstEmployee) {
            if (empTemp.empCode == emp.empCode) {
              isAdd = false;
              break;
            }
          }
          if (isAdd) {
            lstEmployee.add(emp);
          }
        }
      }
    } catch (e) {
      if (lstEmployee.isEmpty) {
        lstEmployee.add(emp);
      } else {
        bool isAdd = true;
        for (EmployeeModel empTemp in lstEmployee) {
          if (empTemp.empCode == emp.empCode) {
            isAdd = false;
            break;
          }
        }
        if (isAdd) {
          lstEmployee.add(emp);
        }
      }
    }
  }

  String handleRequestEmployee() {
    String empCode = '';
    for (EmployeeModel emp in lstEmployee) {
      
    }
    if (empCode.length > 0) {
      empCode = empCode.substring(0, empCode.lastIndexOf(','));
    }
    return empCode;
  }

  void clearData() {
    lstEmployee = [];
  }
}
