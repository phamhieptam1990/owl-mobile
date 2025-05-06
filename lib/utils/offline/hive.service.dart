import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:athena/models/customer-complaint/masterData.model.dart';
import 'package:athena/models/customer-complaint/productType.model.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/mock-location-app/MockLocationApp.model.dart';
import 'package:athena/models/offline/action/checkin/checkin.offline.model.dart';
import 'package:athena/models/offline/category/categoryAll.offline.model.dart';
import 'package:athena/models/offline/customer-complaint/masterData.offline.model.dart';
import 'package:athena/models/offline/customer-complaint/productType.offline.model.dart';
import 'package:athena/models/offline/customer/customer.offline.model.dart';
import 'package:athena/models/offline/employee/employee.offline.model.dart';
import 'package:athena/models/offline/mock-location-app/mockLocationApp.offline.model.dart';
import 'package:athena/models/offline/ticket/activity.offline.model.dart';
import 'package:athena/models/offline/ticket/ticket.offline.model.dart';
import 'package:athena/models/screens/home.model.dart';
import 'package:athena/models/search/search.offline.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/utils/utils.dart';

import '../../models/tracking/app_install.dart/apps_installed.dart';
import '../log/crashlystic_services.dart';

class HiveDBService {
  static bool hiveInit = false;
  static addListProductType(List<ProductTypeModel> lstProductType) async {
    final boxProductType =
        await HiveDBService.openBox(HiveDBConstant.PRODUCT_TYPE);
    if (Utils.checkIsNotNull(boxProductType)) {
      if (checkBoxIsEmpty(boxProductType)) {
        for (ProductTypeModel model in lstProductType) {
          boxProductType.add(ProductTypeOfflineModel.fromJson(model.toJson()));
        }
      } else {
        for (ProductTypeModel model in lstProductType) {
          bool isAdd = true;
          for (int index = 0; index < boxProductType.values.length; index++) {
            ProductTypeOfflineModel modelOffline = boxProductType.getAt(index);
            if (modelOffline.productCode == model.productCode) {
              modelOffline = ProductTypeOfflineModel.fromJson(model.toJson());
              isAdd = false;
              boxProductType.putAt(index, modelOffline);
              break;
            }
          }
          if (isAdd) {
            boxProductType
                .add(ProductTypeOfflineModel.fromJson(model.toJson()));
          }
        }
      }
    }
  }

  static addListMasterDataCustomerComplaint(
      List<MasterDataComplain> lstMasterData) async {
    final boxMasterData =
        await HiveDBService.openBox(HiveDBConstant.MASTER_DATA_COMPLAINT);
    if (Utils.checkIsNotNull(boxMasterData)) {
      if (checkBoxIsEmpty(boxMasterData)) {
        for (MasterDataComplain model in lstMasterData) {
          boxMasterData
              .add(MasterDataComplainOfflineModel.fromJson(model.toJson()));
        }
      } else {
        for (MasterDataComplain model in lstMasterData) {
          bool isAdd = true;
          for (int index = 0; index < boxMasterData.values.length; index++) {
            MasterDataComplainOfflineModel modelOffline =
                boxMasterData.getAt(index);
            if (modelOffline.productCode == model.productCode) {
              modelOffline =
                  MasterDataComplainOfflineModel.fromJson(model.toJson());
              isAdd = false;
              boxMasterData.putAt(index, modelOffline);
              break;
            }
          }
          if (isAdd) {
            boxMasterData
                .add(MasterDataComplainOfflineModel.fromJson(model.toJson()));
          }
        }
      }
    }
    // closeHiveDB();
  }

  static addCollections(List<TicketModel> lstTicket) async {
    try {
      final boxTicketOffline =
          await HiveDBService.openBox(HiveDBConstant.TICKET);
      if (Utils.checkIsNotNull(boxTicketOffline)) {
        if (boxTicketOffline.isEmpty == true) {
          for (TicketModel ticket in lstTicket) {
            var ticketNew = ticket.toJson();
            if (ticketNew['assigneeData'] is EmployeeModel) {
              ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                  ticketNew['assigneeData'].toJson());
            } else {
              ticketNew['assigneeData'] =
                  EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
            }
            boxTicketOffline.add(TicketOfflineModel.fromJson(ticketNew));
          }
        } else {
          for (TicketModel ticket in lstTicket) {
            bool isAdd = true;
            for (int index = 0;
                index < boxTicketOffline.values.length;
                index++) {
              isAdd = true;
              TicketOfflineModel ticketOffline = boxTicketOffline.getAt(index);

              if (ticketOffline.aggId == ticket.aggId) {
                var ticketNew = ticket.toJson();
                if (ticketNew['assigneeData'] is EmployeeModel) {
                  ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                      ticketNew['assigneeData'].toJson());
                } else {
                  ticketNew['assigneeData'] =
                      EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
                }
                boxTicketOffline.putAt(
                    index, TicketOfflineModel.fromJson(ticketNew));
                isAdd = false;
                break;
              }
            }
            if (isAdd) {
              var ticketNew = ticket.toJson();
              if (ticketNew['assigneeData'] is EmployeeModel) {
                ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                    ticketNew['assigneeData'].toJson());
              } else {
                ticketNew['assigneeData'] =
                    EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
              }
              boxTicketOffline.add(TicketOfflineModel.fromJson(ticketNew));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future addCollectionsFuture(List<TicketModel> lstTicket) async {
    try {
      final boxTicketOffline =
          await HiveDBService.openBox(HiveDBConstant.TICKET);
      if (Utils.checkIsNotNull(boxTicketOffline)) {
        if (boxTicketOffline.isEmpty == true) {
          for (TicketModel ticket in lstTicket) {
            var ticketNew = ticket.toJson();
            if (ticketNew['assigneeData'] is EmployeeModel) {
              ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                  ticketNew['assigneeData'].toJson());
            } else {
              if (Utils.checkIsNotNull(ticketNew['assigneeData'])) {
                ticketNew['assigneeData'] =
                    EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
              }
            }
            boxTicketOffline.add(TicketOfflineModel.fromJson(ticketNew));
          }
        } else {
          for (TicketModel ticket in lstTicket) {
            bool isAdd = true;
            for (int index = 0;
                index < boxTicketOffline.values.length;
                index++) {
              isAdd = true;
              TicketOfflineModel ticketOffline = boxTicketOffline.getAt(index);

              if (ticketOffline.aggId == ticket.aggId) {
                var ticketNew = ticket.toJson();
                if (ticketNew['assigneeData'] is EmployeeModel) {
                  ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                      ticketNew['assigneeData'].toJson());
                } else {
                  ticketNew['assigneeData'] =
                      EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
                }
                boxTicketOffline.putAt(
                    index, TicketOfflineModel.fromJson(ticketNew));
                isAdd = false;
                break;
              }
            }
            if (isAdd) {
              var ticketNew = ticket.toJson();
              if (ticketNew['assigneeData'] is EmployeeModel) {
                ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                    ticketNew['assigneeData'].toJson());
              } else {
                ticketNew['assigneeData'] =
                    EmployeeOfflineModel.fromJson(ticketNew['assigneeData']);
              }
              boxTicketOffline.add(TicketOfflineModel.fromJson(ticketNew));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static updateCollections(TicketModel ticketModel) async {
    try {
      final boxTicketOffline =
          await HiveDBService.openBox(HiveDBConstant.TICKET);
      if (Utils.checkIsNotNull(boxTicketOffline)) {
        for (int index = 0; index < boxTicketOffline.values.length; index++) {
          TicketOfflineModel ticketOffline = boxTicketOffline.getAt(index);
          if (ticketOffline.aggId == ticketModel.aggId) {
            var ticketNew = ticketModel.toJson();
            if (Utils.checkIsNotNull(ticketNew['assigneeData'])) {
              ticketNew['assigneeData'] = EmployeeOfflineModel.fromJson(
                  ticketNew['assigneeData'].toJson());
            }
            boxTicketOffline.putAt(
                index, TicketOfflineModel.fromJson(ticketNew));
            break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future addEmployeesFuture(List<EmployeeModel> employees) async {
    final boxEmployeeModel =
        await HiveDBService.openBox(HiveDBConstant.EMMPLOYEE);
    if (Utils.checkIsNotNull(boxEmployeeModel)) {
      if (boxEmployeeModel.isEmpty == true) {
        for (EmployeeModel emp in employees) {
          boxEmployeeModel.add(EmployeeOfflineModel.fromJson(emp.toJson()));
        }
      } else {
        for (EmployeeModel model in employees) {
          bool isAdd = true;
          for (int index = 0; index < boxEmployeeModel.values.length; index++) {
            EmployeeOfflineModel empOffline = boxEmployeeModel.getAt(index);
            if (empOffline.empCode == model.empCode) {
              empOffline = EmployeeOfflineModel.fromJson(model.toJson());
              isAdd = false;
              boxEmployeeModel.putAt(index, empOffline);
              break;
            }
          }
          if (isAdd) {
            boxEmployeeModel.add(EmployeeOfflineModel.fromJson(model.toJson()));
          }
        }
      }
    }
  }

  static addEmployees(List<EmployeeModel> employees) async {
    final boxEmployeeModel =
        await HiveDBService.openBox(HiveDBConstant.EMMPLOYEE);
    if (Utils.checkIsNotNull(boxEmployeeModel)) {
      if (boxEmployeeModel.isEmpty == true) {
        for (EmployeeModel emp in employees) {
          boxEmployeeModel.add(EmployeeOfflineModel.fromJson(emp.toJson()));
        }
      } else {
        for (EmployeeModel model in employees) {
          bool isAdd = true;
          for (int index = 0; index < boxEmployeeModel.values.length; index++) {
            EmployeeOfflineModel empOffline = boxEmployeeModel.getAt(index);
            if (empOffline.empCode == model.empCode) {
              empOffline = EmployeeOfflineModel.fromJson(model.toJson());
              isAdd = false;
              boxEmployeeModel.putAt(index, empOffline);
              break;
            }
          }
          if (isAdd) {
            boxEmployeeModel.add(EmployeeOfflineModel.fromJson(model.toJson()));
          }
        }
      }
    }
  }

  static addMockLocationApp(List<MockLocationAppModel> mockLocationApps) async {
    final boxMockLocationApps =
        await HiveDBService.openBox(HiveDBConstant.MOCK_LOCATION_APPS);
    if (Utils.checkIsNotNull(boxMockLocationApps)) {
      if (boxMockLocationApps.isEmpty == true) {
        for (MockLocationAppModel app in mockLocationApps) {
          boxMockLocationApps
              .add(MockLocationAppOfflineModel.fromJson(app.toJson()));
        }
      } else {
        for (MockLocationAppModel app in mockLocationApps) {
          bool isAdd = true;
          for (int index = 0;
              index < boxMockLocationApps.values.length;
              index++) {
            MockLocationAppOfflineModel appOffline =
                boxMockLocationApps.getAt(index);
            if (app.id == appOffline.id) {
              isAdd = false;
              break;
            }
          }
          if (isAdd) {
            boxMockLocationApps
                .add(MockLocationAppOfflineModel.fromJson(app.toJson()));
          }
        }
      }
    }
  }

  static addDataHomeScreen(int _paid, int _unpaid, int _proposeCalendar,
      int _doneActionCalendar) async {
    final homeScreenBox =
        await HiveDBService.openBox(HiveDBConstant.HOME_SCREEN);
    if (Utils.checkIsNotNull(homeScreenBox)) {
      if (homeScreenBox.isEmpty == true) {
        homeScreenBox.add(HomeModel(
            paid: _paid,
            unPaid: _unpaid,
            proposeCalendar: _proposeCalendar,
            doneActionCalendar: _doneActionCalendar));
      } else {
        HomeModel homeModel = homeScreenBox.getAt(0);
        homeModel.paid = _paid;
        homeModel.unPaid = _unpaid;
        homeModel.proposeCalendar = _proposeCalendar;
        homeModel.doneActionCalendar = _doneActionCalendar;
        homeModel.save();
      }
      // if (homeScreenBox.isOpen) {
      //   await homeScreenBox.close();
      // }
    }
  }

  static searchCollectionTicket(String keyword) async {
    try {
      final boxTicketOffline =
          await HiveDBService.openBox(HiveDBConstant.TICKET);
      if (Utils.checkIsNotNull(boxTicketOffline)) {
        if (boxTicketOffline.isEmpty == false) {
          // boxTicketOffline.values.where((item) => item.value == keyword)
          //   .forEach((item) => {

          //   });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static addCheckInOffline(CheckInOfflineModel checkInOfflineModel) async {
    try {
      final boxCheckInOffline =
          await HiveDBService.openBox(HiveDBConstant.CHECK_IN_OFFLINE);
      if (Utils.checkIsNotNull(boxCheckInOffline)) {
        if (boxCheckInOffline.isEmpty == true) {
          boxCheckInOffline.add(checkInOfflineModel);
        } else {
          bool isAdd = true;
          for (int index = 0;
              index < boxCheckInOffline.values.length;
              index++) {
            CheckInOfflineModel checkInOfflineModelTemp =
                boxCheckInOffline.getAt(index);
            if (checkInOfflineModelTemp.offlineInfo['uuid'] ==
                checkInOfflineModel.offlineInfo['uuid']) {
              isAdd = false;
              break;
            }
          }
          if (isAdd) {
            boxCheckInOffline.add(checkInOfflineModel);
          }
        }
        if (boxCheckInOffline.isOpen) {
          await boxCheckInOffline.close();
        }
      }
    } catch (e) {
      CrashlysticServices.instance.log(e.toString());
    }
  }

  static addCategory(Map<String, dynamic> newLstData, var fetmActionReason,
      var localityData) async {
    try {
      final boxCategoryData =
          await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
      CategoryAllOfflineModel _categoryAllOfflineModel = new CategoryAllOfflineModel();
      bool isAdd = false;
      if (Utils.checkIsNotNull(boxCategoryData)) {
        if (boxCategoryData.isEmpty == true) {
          _categoryAllOfflineModel = new CategoryAllOfflineModel();
          isAdd = true;
        } else if (boxCategoryData.getAt(0) != null) {
          _categoryAllOfflineModel = boxCategoryData.getAt(0);
        }
        _categoryAllOfflineModel.fetbFieldActions =
            newLstData['fetbFieldActions'];
        _categoryAllOfflineModel.fetmActionAttribute =
            newLstData['fetmActionAttribute'];
        _categoryAllOfflineModel.fetmContactPeoples =
            newLstData['fetmContactPeoples'];
        _categoryAllOfflineModel.fetmContactPlaces =
            newLstData['fetmContactPlaces'];
        _categoryAllOfflineModel.fetmContactMode =
            newLstData['fetmContactMode'];
        _categoryAllOfflineModel.fetmActionGroups =
            newLstData['fetmActionGroups'];
        _categoryAllOfflineModel.fetmFieldTypes = newLstData['fetmFieldTypes'];
        _categoryAllOfflineModel.fetmActionSubAttribute =
            newLstData['fetmActionSubAttribute'];
        _categoryAllOfflineModel.fetmFieldReason = fetmActionReason;
        _categoryAllOfflineModel.locality = localityData;

        if (isAdd) {
          boxCategoryData.add(_categoryAllOfflineModel);
        } else {
          _categoryAllOfflineModel.save();
        }
      }
      if (boxCategoryData.isOpen) {
        boxCategoryData.close();
      }
    } catch (e) {
      print(e);
    }
  }

  static addCategoryLocality(var localityData) async {
    try {
      final boxCategoryData =
          await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
      CategoryAllOfflineModel _categoryAllOfflineModel;
      if (Utils.checkIsNotNull(boxCategoryData)) {
        if (boxCategoryData.getAt(0) != null) {
          _categoryAllOfflineModel = boxCategoryData.getAt(0);
          _categoryAllOfflineModel.locality = localityData;
          _categoryAllOfflineModel.save();
        }
        if (boxCategoryData.isOpen) {
          boxCategoryData.close();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static openBoxesCategory() async {
    try {
      final boxCategoryData =
          await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
      CategoryAllOfflineModel _categoryAllOfflineModel = new CategoryAllOfflineModel();
      if (Utils.checkIsNotNull(boxCategoryData)) {
        if (boxCategoryData.isEmpty == true) {
          _categoryAllOfflineModel = new CategoryAllOfflineModel();
        } else if (boxCategoryData.getAt(0) != null) {
          _categoryAllOfflineModel = boxCategoryData.getAt(0);
        }
        _categoryAllOfflineModel.save();
      }
      boxCategoryData.close();
    } catch (e) {
      print(e);
    }
  }

  // static openBoxesCheckIn() async {
  //   try {
  //     final boxCategoryData =
  //         await HiveDBService.openBox(HiveDBConstant.CHECK_IN_OFFLINE);
  //     CategoryAllOfflineModel _categoryAllOfflineModel;
  //     if (Utils.checkIsNotNull(boxCategoryData)) {
  //       if (boxCategoryData.isEmpty == true) {
  //         _categoryAllOfflineModel = new CategoryAllOfflineModel();
  //       } else if (boxCategoryData.getAt(0) != null) {
  //         _categoryAllOfflineModel = boxCategoryData.getAt(0);
  //       }
  //     }
  //     boxCategoryData.close();
  //   } catch (e) {
  //   }
  // }

  static void registerAdapter() {
    Hive.registerAdapter(EmployeeOfflineModelAdapter());
    Hive.registerAdapter(CategoryAllOfflineModelAdapter());
    Hive.registerAdapter(CustomerOfflineModelAdapter());
    Hive.registerAdapter(MasterDataComplainOfflineModelAdapter());
    Hive.registerAdapter(ActivityOfflineModelAdapter());
    Hive.registerAdapter(TicketOfflineModelAdapter());
    Hive.registerAdapter(ProductTypeOfflineModelAdapter());
    Hive.registerAdapter(CheckInOfflineModelAdapter());
    Hive.registerAdapter(MockLocationAppOfflineModelAdapter());
    Hive.registerAdapter(HomeModelAdapter());
    Hive.registerAdapter(SearchOfflineModelAdapter());

    //init adapter app installl
    Hive.registerAdapter(AppsInstalledAdapter());
    Hive.registerAdapter(AppsInstalledElementAdapter());

    hiveInit = true;
  }

  static closeHiveDB() {
    Hive.close();
  }

  static Future clearHiveBox(String _box) async {
    final boxes = await HiveDBService.openBox(_box);
    await boxes?.clear();
  }

  static Future clearAllBox() async {
    await clearHiveBox(HiveDBConstant.CATEGORY_ALL);
    await clearHiveBox(HiveDBConstant.PRODUCT_TYPE);
    await clearHiveBox(HiveDBConstant.TICKET);
    await clearHiveBox(HiveDBConstant.EMMPLOYEE);
    await clearHiveBox(HiveDBConstant.MASTER_DATA_COMPLAINT);
    await clearHiveBox(HiveDBConstant.HOME_SCREEN);
    //adjust clear Search Screen box    await clearHiveBox(HiveDBConstant.SEARCH_SCREEN);
    Box<SearchOfflineModel> searchHistoryBox =
        Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN);
    searchHistoryBox.clear();
    //Clear AppsInstallBox
    Box<AppsInstalled> appsInstalled = await openAppInstall();
    appsInstalled.clear();
  }

  static Future<void> initHiveDB() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    registerAdapter();
    await Hive.openBox<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN);
  }

  static dynamic getValuesData(var data) {
    return data.values;
  }

  static bool checkValuesInBoxesIsNotEmpty(dynamic boxes) {
    if (boxes != null) {
      var data = getValuesData(boxes);
      if (!data.isEmpty) {
        return true;
      }
    }
    return false;
  }

  static bool checkBoxIsEmpty(dynamic boxes) {
    if (boxes.isEmpty) {
      return true;
    }
    return false;
  }

  static Future openBox(String box) async {
    if (Hive.isBoxOpen(box)) {
      return Hive.box(box);
    }
    return await Hive.openBox(box);
  }

  static Future<Box<AppsInstalled>> openAppInstall() async {
    if (Hive.isBoxOpen(HiveDBConstant.APPS_INSTALLED)) {
      return Hive.box<AppsInstalled>(HiveDBConstant.APPS_INSTALLED);
    }
    return await Hive.openBox<AppsInstalled>(HiveDBConstant.APPS_INSTALLED);
  }

  // static Future openBoxNew(String box) async {
  //   if (Hive.isBoxOpen(box)) {
  //     return Hive.box(box);
  //   }
  //   return await Hive.openBox(box);
  // }

  static final HiveDBService _hiveDBService = HiveDBService._internal();

  factory HiveDBService() {
    return _hiveDBService;
  }

  HiveDBService._internal();
}

class HiveDBConstant {
  static const BOX = 'BOX';
  static const CATEGORY_ALL = 'CATEGORY_ALL';
  static const TICKET = 'TICKET';
  static const EMMPLOYEE = 'EMMPLOYEE';
  static const PRODUCT_TYPE = 'PRODUCT_TYPE';
  static const MASTER_DATA_COMPLAINT = 'MASTER_DATA_COMPLAINT';
  static const CHECK_IN_OFFLINE = 'CHECK_IN_OFFLINE';
  static const VERSION_ANDROID = 'VERSION_ANDROID';
  static const VERSION_IOS = 'VERSION_IOS';
  static const VERSION_ANDROID_UAT = 'VERSION_ANDROID_UAT';
  static const VERSION_IOS_UAT = 'VERSION_IOS_UAT';
  static const MOCK_LOCATION_APPS = 'MOCK_LOCATION_APPS';
  static const HOME_SCREEN = 'HOME_SCREEN';
  static const SEARCH_SCREEN = 'SEARCH_SCREEN';

  // app install compare to submit firestore services
  static const APPS_INSTALLED = 'APPS_INSTALLED';
  //key save APPS_INSTALLED
  static const APPS_INSTALLED_KEY = 'APPS_INSTALLED_KEY';
}
