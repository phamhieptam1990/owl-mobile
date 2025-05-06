import 'package:dio/dio.dart';
import 'package:athena/models/category/action_attribute_ticket.model.dart';
import 'package:athena/models/category/action_sub_attribute_model.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/models/category/attribute_ticket.model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/customer_attitude.model.dart';
import 'package:athena/models/category/field_actions.model.dart';
import 'package:athena/models/category/loan_type_ticket.model.dart';
import 'package:athena/models/category/locality.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/offline/category/categoryAll.offline.model.dart';
import 'package:athena/models/wallet_list/payment_methods_response.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/widgets/common/common.dart';

import '../../../common/config/app_config.dart';
import '../../../common/constants/general.dart';
import '../../http/http_helper.dart';
import '../../utils.dart';

class CategorySingeton {
  final _categoryService = new CategoryService();
  var categoryAll;
  var fetmFieldReason;
  var localityData;
  List<CustomerAttitudeModel> lstCustomerAttitudeModel = [
    CustomerAttitudeModel('Bình Thường', 1),
    CustomerAttitudeModel('Không hợp tác', 2),
    CustomerAttitudeModel('Phản ứng gay gắt, đe dọa, thách thức', 3),
  ];
  List<CustomerAttitudeModel> lstCheckInType = [
    CustomerAttitudeModel('Hoạt động Kinh doanh của Khách hàng', '1'),
    CustomerAttitudeModel('Người thân thanh toán hộ', '2'),
    CustomerAttitudeModel('Vay mượn', '3'),
  ];
  List<FieldActions> lstFieldActions = [];
  List<FieldActions> get getLstFieldActions => lstFieldActions;

  set setLstFieldActions(List<FieldActions> lstFieldActions) =>
      this.lstFieldActions = lstFieldActions;
  List<ActionTicketModel> lstActionModel = [];
  List<ActionTicketModel> get getLstActionModel => lstActionModel;

  set setLstActionModel(List<ActionTicketModel> lstActionModel) =>
      this.lstActionModel = lstActionModel;

  List<ActionTicketModel> lstActionReason = [];
  List<ActionTicketModel> get getLstActionReason => lstActionReason;

  set setLstActionReason(List<ActionTicketModel> lstActionReason) =>
      this.lstActionReason = lstActionReason;
  List<ContactByTicketModel> lstContactByTicketModel = [];
  List<ContactByTicketModel> get getLstContactByTicketM =>
      lstContactByTicketModel;

  set setLstContactByTicketM(List<ContactByTicketModel> lstContactByTicketM) =>
      this.lstContactByTicketModel = lstContactByTicketM;

  List<ContactPersonTicketModel> lstContactPersonTicketModel = [];
  List<ContactPersonTicketModel> get getLstContactPersonTicketModel =>
      lstContactPersonTicketModel;

  set setLstContactPersonTicketModel(
          List<ContactPersonTicketModel> lstContactPersonTicketModel) =>
      this.lstContactPersonTicketModel = lstContactPersonTicketModel;
  List<LoanTypeTicketModel> lstLoanTypeTicketModel = [];
  List<LoanTypeTicketModel> get getLstLoanTypeTicketM => lstLoanTypeTicketModel;

  set setLstLoanTypeTicketM(List<LoanTypeTicketModel> lstLoanTypeTicketM) =>
      this.lstLoanTypeTicketModel = lstLoanTypeTicketM;
  List<PlaceContactTicketModel> lstPlaceContactTicketModel = [];
  List<PlaceContactTicketModel> get getLstPlaceContactTicketModel =>
      lstPlaceContactTicketModel;

  set setLstPlaceContactTicketModel(
          List<PlaceContactTicketModel> lstPlaceContactTicketModel) =>
      this.lstPlaceContactTicketModel = lstPlaceContactTicketModel;
  List<StatusTicketModel> lstStatusTicketModel = [];
  List<StatusTicketModel> get getLstStatusTicketModel => lstStatusTicketModel;

  set setLstStatusTicketModel(List<StatusTicketModel> lstStatusTicketModel) =>
      this.lstStatusTicketModel = lstStatusTicketModel;

  List<AttributeTicketModel> lstAttributeTicketModel = [];
  List<AttributeTicketModel> get getLstAttributeTicketModel =>
      lstAttributeTicketModel;

  set setLstAttributeTicketModel(
          List<AttributeTicketModel> lstAttributeTicketModel) =>
      this.lstAttributeTicketModel = lstAttributeTicketModel;

  List<ActionAttributeTicketModel> lstActionAttributeTicketModel = [];
  List<ActionAttributeTicketModel> get getLstActionAttributeTicketModel =>
      lstActionAttributeTicketModel;

  set setLstActionAttributeTicketModel(
          List<ActionAttributeTicketModel> lstActionAttributeTicketModel) =>
      this.lstActionAttributeTicketModel = lstActionAttributeTicketModel;

  List<LocalityModel> lstLocalityModel = [];
  List<LocalityModel> get getlstLocalityModel => lstLocalityModel;

  List<LocalityModel> lstCity = [];
  List<LocalityModel> get getlstCity => lstCity;

  List<LocalityModel> lstProvince = [];
  List<LocalityModel> get getlstProvince => lstProvince;

  List<LocalityModel> lstWard = [];
  List<LocalityModel> get getlstWard => lstLocalityModel;

  List<PaymentMethodsData> paymentMethods = [];

  List<ActionSubAttributeModel> actionSubAttributeModels =
      <ActionSubAttributeModel>[];

  void clearData() {
    lstActionModel = [];
    lstContactByTicketModel = [];
    lstPlaceContactTicketModel = [];
    lstStatusTicketModel = [];
    lstLoanTypeTicketModel = [];
    lstAttributeTicketModel = [];
    lstContactPersonTicketModel = [];
    lstActionReason = [];
    lstFieldActions = [];
    lstActionAttributeTicketModel = [];
    actionSubAttributeModels = [];
    lstLocalityModel = [];
    lstCity = [];
    lstWard = [];
    lstWard = [];
    categoryAll = null;
    paymentMethods = [];
  }

  List<ContactPersonTicketModel> initDataListContactPerson(int? actionGroupId) {
    List<ContactPersonTicketModel> lstContactPerson =
        this.getLstContactPersonTicketModel;
    List<FieldActions> lstActionTicketModel = this.getLstFieldActions;
    List<ContactPersonTicketModel> lstContactPersonFinal = [];
    List<int> lstTemp = [];
    if (Utils.isArray(lstActionTicketModel)) {
      for (FieldActions action in lstActionTicketModel) {
        if (action.actionGroupId == actionGroupId) {
          lstTemp.add(action.contactPersonId ?? 0);
        }
      }
      if (Utils.isArray(lstTemp)) {
        lstTemp = lstTemp.toSet().toList();
        for (int index = 0; index < lstTemp.length; index++) {
          if (Utils.checkIsNotNull(lstTemp[index])) {
            for (int jindex = 0; jindex < lstContactPerson.length; jindex++) {
              if (lstContactPerson[jindex].id == lstTemp[index]) {
                lstContactPersonFinal.add(lstContactPerson[jindex]);
                break;
              }
            }
          }
        }
      }
    }
    return lstContactPersonFinal;
  }

  Future<void> getPaymentMethods() async {
    try {
      final response =
          await HttpHelper.get(SERVICE_URL.MCRSMP['GET_PAYMENT_METHODS'] ?? '');
      final paymentMethodsData = PaymentMethodsResponse.fromJson(response.data);
      if (paymentMethodsData.status == 0) {
        paymentMethods = paymentMethodsData.data ?? [];
      }
    } catch (_) {}
  }

  Future<void> initAllCateogyData(
      {isClearData = false, bool isProgress = false}) async {
    try {
      if (isProgress) {
        WidgetCommon.showLoading(
            status: 'Đang đồng bộ dữ liệu', dismissOnTap: false);
      }
      if (isClearData) {
        this.categoryAll = null;
        this.lstActionModel = [];
      }
      // if (this.getlstLocalityModel.length == 0 &&
      //     Utils.checkIsNotNull(this.categoryAll)) {
      //   _categoryService.getAllLocality().then((value) {
      //     if (value.statusCode == 200 && value.statusMessage == 'OK') {
      //       final data = value.data;
      //       if (Utils.checkIsNotNull(data)) {
      //         final dataLocality = data['data'];
      //         if (Utils.isArray(dataLocality)) {
      //           this.categoryAll['locality'] = dataLocality;
      //           localityData = dataLocality;
      //           if (this.getlstLocalityModel.isEmpty) {
      //             for (var data in dataLocality) {
      //               this.getlstLocalityModel.add(LocalityModel.fromJson(data));
      //             }
      //           }
      //           HiveDBService.addCategoryLocality(localityData);
      //         }
      //       }
      //     }
      //   });
      // }
      if (Utils.checkIsNotNull(this.categoryAll)) {
        return;
      }
      bool isShowLoading = true;
      if (this.categoryAll == null) {
        final boxCategoryAll =
            await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
        if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxCategoryAll)) {
          isShowLoading = false;
          CategoryAllOfflineModel _categoryAllOfflineModel =
              boxCategoryAll.getAt(0);
          this.categoryAll = _categoryAllOfflineModel.toJson();
          final fetmFieldReason = this.categoryAll['fetmFieldReason'];
          if (Utils.isArray(fetmFieldReason) &&
              this.getLstActionModel.isEmpty) {
            for (var data in fetmFieldReason) {
              this.getLstActionModel.add(ActionTicketModel.fromJson(data));
            }
          }
          final locality = this.categoryAll['locality'];
          if (Utils.isArray(locality) && this.getlstLocalityModel.isEmpty) {
            for (var data in locality) {
              this.getlstLocalityModel.add(LocalityModel.fromJson(data));
            }
          }
          generataCategoryAll(this.categoryAll);
        }
        if (MyConnectivity.instance.isOffline) {
          final boxCategoryAll =
              await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
          if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxCategoryAll)) {
            CategoryAllOfflineModel _categoryAllOfflineModel =
                boxCategoryAll.getAt(0);
            this.categoryAll = _categoryAllOfflineModel.toJson();
            final fetmFieldReason = this.categoryAll['fetmFieldReason'];
            if (Utils.isArray(fetmFieldReason) &&
                this.getLstActionModel.isEmpty) {
              for (var data in fetmFieldReason) {
                this.getLstActionModel.add(ActionTicketModel.fromJson(data));
              }
            }
            final locality = this.categoryAll['locality'];
            if (Utils.isArray(locality) && this.getlstLocalityModel.isEmpty) {
              for (var data in locality) {
                this.getlstLocalityModel.add(LocalityModel.fromJson(data));
              }
            }
            generataCategoryAll(this.categoryAll);
          }
        } else {
          await initActionModel();
          Response response = await _categoryService.getAllCategory();
          if (Utils.checkRequestIsComplete(response)) {
            this.categoryAll = Utils.handleRequestData(response);
            // await MasterDataManager.saveCacheCurrentVersion();
            generataCategoryAll(this.categoryAll, isReloadFromServer: true);
            if (this.getLstActionModel.length == 0 &&
                Utils.isArray(fetmFieldReason)) {
              for (var data in fetmFieldReason) {
                this.getLstActionModel.add(ActionTicketModel.fromJson(data));
              }
            }
            loadLocallity(fetmFieldReason);
          } else {
            WidgetCommon.dismissLoading();
          }
        }
      }
    } catch (e) {
      WidgetCommon.dismissLoading();
    } finally {
      WidgetCommon.dismissLoading();
    }
  }

  void loadLocallity(fetmFieldReason) {
    try {
      if (this.getlstLocalityModel.length > 0) {
        if (!Utils.checkIsNotNull(this.categoryAll['locality']) &&
            Utils.checkIsNotNull(localityData)) {
          this.categoryAll['locality'] = localityData;
        }
        WidgetCommon.dismissLoading();

        HiveDBService.addCategory(
            this.categoryAll, fetmFieldReason, localityData);
        return;
      }
      _categoryService.getAllLocality().then((value) {
        if (value.statusCode == 200 && value.statusMessage == 'OK') {
          final data = value.data;
          if (Utils.checkIsNotNull(data)) {
            final dataLocality = data['data'];
            if (Utils.isArray(dataLocality)) {
              this.categoryAll['locality'] = dataLocality;
              localityData = dataLocality;
              if (this.getlstLocalityModel.isEmpty) {
                // for (var data in dataLocality) {
                //   this.getlstLocalityModel.add(LocalityModel.fromJson(data));
                // }
                List<LocalityModel> lstLocality = [];
                for (var data in dataLocality) {
                  lstLocality.add(LocalityModel.fromJson(data));
                }
                this.lstLocalityModel = lstLocality;
              }
              WidgetCommon.dismissLoading();
              HiveDBService.addCategory(
                  this.categoryAll, fetmFieldReason, localityData);
            }
          }
        }
      });
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
  }

  Map<String, String> getDataCityProvinceWard(
      int? cityId, int? provinceId, int? wardId) {
    String city = '';
    String ward = '';
    String province = '';

    if (getlstLocalityModel.isNotEmpty) {
      if (wardId != null) {
        final lstLocalityModel = getlstLocalityModel;
        for (var data in lstLocalityModel) {
          if (city.isEmpty || province.isEmpty || ward.isEmpty) {
            if (data.id == cityId) {
              city = data.name ?? '';
            } else if (data.id == provinceId) {
              province = data.name ?? '';
            } else if (data.id == wardId) {
              ward = data.name ?? '';
            }
          } else if (city.isNotEmpty &&
              province.isNotEmpty &&
              ward.isNotEmpty) {
            break;
          }
        }
      } else {
        final lstLocalityModel = getlstLocalityModel;
        for (var data in lstLocalityModel) {
          if (city.isEmpty || province.isEmpty) {
            if (data.id == cityId) {
              city = data.name ?? '';
            } else if (data.id == provinceId) {
              province = data.name ?? '';
            }
          } else if (city.isNotEmpty && province.isNotEmpty) {
            break;
          }
        }
      }
    } else {
      // This condition seems redundant since we already checked if getlstLocalityModel is empty
      // But keeping similar logic with null safety fixes
      if (getlstLocalityModel.isNotEmpty) {
        if (wardId != null) {
          final lstLocalityModel = getlstLocalityModel;
          for (var data in lstLocalityModel) {
            if (city.isEmpty || province.isEmpty) {
              if (data.id == cityId) {
                city = data.name ?? '';
              } else if (data.id == provinceId) {
                province = data.name ?? '';
              }
            } else if (city.isNotEmpty && province.isNotEmpty) {
              break;
            }
          }
        }
      }
    }

    return {'city': city, 'province': province, 'ward': ward};
  }

  void loadListCity() {
    if (this.getlstLocalityModel.isNotEmpty && this.lstCity.isEmpty) {
      final lstLocalityModel = this.getlstLocalityModel;
      for (var data in lstLocalityModel) {
        if (data.localityTypeId == 1) {
          this.getlstCity.add(data);
        }
      }
    }
  }

  void loadProvince(LocalityModel? city) {
    this.lstProvince = [];
    this.lstWard = [];
    if (this.lstCity.isNotEmpty) {
      final lstLocalityModel = this.getlstLocalityModel;
      for (var data in lstLocalityModel) {
        if (data.localityTypeId == 2 && city?.id == data.parentId) {
          this.lstProvince.add(data);
        }
      }
    }
  }

  void loadWard(LocalityModel? province) {
    if (Utils.checkIsNotNull(province)) if (this.getlstLocalityModel.length >
        0) {
      this.lstWard = [];
      final lstLocalityModel = this.getlstLocalityModel;
      for (var data in lstLocalityModel) {
        if (data.localityTypeId == 3 && data.parentId == province?.id) {
          this.lstWard.add(data);
        }
      }
    }
  }

  void generataCategoryAll(newLstData,
      {bool isReloadFromServer = false}) async {
    if (newLstData != null) {
      if (isReloadFromServer = true) {
        //
        lstContactPersonTicketModel = [];
        lstPlaceContactTicketModel = [];
        lstContactByTicketModel = [];
        lstFieldActions = [];
        lstStatusTicketModel = [];
        lstStatusTicketModel = [];
        actionSubAttributeModels = [];
      }

      if (this.getLstContactPersonTicketModel.isEmpty) {
        var fetmContactPeoples = newLstData['fetmContactPeoples'];
        if (Utils.isArray(fetmContactPeoples)) {
          for (var data in fetmContactPeoples) {
            this
                .getLstContactPersonTicketModel
                .add(ContactPersonTicketModel.fromJson(data));
          }
        }
      }
      if (this.getLstPlaceContactTicketModel.isEmpty) {
        var fetmContactPlaces = newLstData['fetmContactPlaces'];
        if (Utils.isArray(fetmContactPlaces)) {
          for (var data in fetmContactPlaces) {
            this
                .getLstPlaceContactTicketModel
                .add(PlaceContactTicketModel.fromJson(data));
          }
        }
      }
      if (this.getLstContactByTicketM.isEmpty) {
        var fetmContactMode = newLstData['fetmContactMode'];
        if (Utils.isArray(fetmContactMode)) {
          for (var data in fetmContactMode) {
            this
                .getLstContactByTicketM
                .add(ContactByTicketModel.fromJson(data));
          }
        }
      }
      if (this.getLstFieldActions.isEmpty) {
        var fetbFieldActions = newLstData['fetbFieldActions'];
        if (Utils.isArray(fetbFieldActions)) {
          for (var data in fetbFieldActions) {
            this.getLstFieldActions.add(FieldActions.fromJson(data));
          }
        }
      }
      if (this.getLstStatusTicketModel.isEmpty) {
        var fetmActionGroups = this.categoryAll['fetmActionGroups'];
        if (Utils.isArray(fetmActionGroups)) {
          for (var data in fetmActionGroups) {
            this.getLstStatusTicketModel.add(StatusTicketModel.fromJson(data));
          }
        }
      }
      if (this.getLstActionAttributeTicketModel.isEmpty) {
        var fetmActionAttributes = this.categoryAll['fetmActionAttribute'];
        if (Utils.isArray(fetmActionAttributes)) {
          for (var data in fetmActionAttributes) {
            this
                .getLstActionAttributeTicketModel
                .add(ActionAttributeTicketModel.fromJson(data));
          }
        }
      }
      if (actionSubAttributeModels.isEmpty ?? false) {
        var fetmActionSubAttribute = this.categoryAll['fetmActionSubAttribute'];
        if (Utils.isArray(fetmActionSubAttribute)) {
          for (var data in fetmActionSubAttribute) {
            actionSubAttributeModels
                .add(ActionSubAttributeModel.fromJson(data));
          }
        }
      }
    }
  }

  void initStatusAction() {
    if (this.getLstStatusTicketModel.length > 0) {
      return;
    }
    var fetmActionGroups = this.categoryAll['fetmActionGroups'];
    if (Utils.isArray(fetmActionGroups)) {
      for (var data in fetmActionGroups) {
        this.getLstStatusTicketModel.add(StatusTicketModel.fromJson(data));
      }
    }
  }

  Future<void> initActionModel() async {
    if (this.getLstActionModel.length > 0) {
      return;
    }
    try {
      Response response = await _categoryService.getActionTicket();
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData(response);
        if (Utils.isArray(lstData)) {
          fetmFieldReason = lstData;
          if (this.getLstActionModel.length > 0) {
            return;
          }
          for (var data in lstData) {
            this.getLstActionModel.add(ActionTicketModel.fromJson(data));
          }
        }
      }
    } catch (e) {}
  }

  // List<StatusTicketModel> lstStatusTicketModel = [];

  Future setStatusTicketModelOffline() async {
    final boxCategoryData =
        await HiveDBService.openBox(HiveDBConstant.CATEGORY_ALL);
    if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxCategoryData)) {
      CategoryAllOfflineModel _categoryAllOfflineModel =
          boxCategoryData.getAt(0);
      // var fetmActionGroups = _categoryAllOfflineModel.fetmActionGroups;
    }
  }

  ContactByTicketModel setDefaultContactByTicketModel(
      {String actionGroupCode = ""}) {
    for (int index = 0; index < getLstContactByTicketM.length; index++) {
      if (actionGroupCode == FieldTicketConstant.OTHER_CALL &&
          getLstContactByTicketM[index].modeCode == 'CV') {
        return getLstContactByTicketM[index];
      } else if (actionGroupCode != FieldTicketConstant.OTHER_CALL &&
          getLstContactByTicketM[index].modeCode == 'FV') {
        return getLstContactByTicketM[index];
      }
    }
    return new ContactByTicketModel();
  }

  static final CategorySingeton _categorySingeton =
      CategorySingeton._internal();

  factory CategorySingeton() {
    return _categorySingeton;
  }

  CategorySingeton._internal() {
    // Initialize any necessary fields that weren't initialized at declaration
    paymentMethods = [];
  }
  Future<void> backgroundUpdateCategoryAll({bool isClearData = false}) async {
    try {
      WidgetCommon.showLoading();
      Response response = await _categoryService.getAllCategory();
      if (Utils.checkRequestIsComplete(response)) {
        this.categoryAll = Utils.handleRequestData(response);
        generataCategoryAll(this.categoryAll);
        if (this.getLstActionModel.length == 0 &&
            Utils.isArray(fetmFieldReason)) {
          for (var data in fetmFieldReason) {
            this.getLstActionModel.add(ActionTicketModel.fromJson(data));
          }
        }
        loadLocallity(fetmFieldReason);
      } else {
        WidgetCommon.dismissLoading();
      }

      WidgetCommon.dismissLoading();
    } catch (_) {
      WidgetCommon.dismissLoading();
    }
  }

  void updateCategory(Map<String, dynamic> parameters) async {
    try {
      bool isClearData = parameters['isClearData'];
      final response = parameters['response'];
      if (response == null) {
        return;
      }
      if (isClearData ?? false) {
        this.categoryAll = null;
        this.lstActionModel = [];
      }

      if (Utils.checkRequestIsComplete(response)) {
        this.categoryAll = Utils.handleRequestData(response);
        generataCategoryAll(categoryAll);
        if (this.getLstActionModel.length == 0 &&
            Utils.isArray(fetmFieldReason)) {
          for (var data in fetmFieldReason) {
            this.getLstActionModel.add(ActionTicketModel.fromJson(data));
          }
        }
        loadLocallity(fetmFieldReason);
      }
    } catch (_) {}
  }
}
