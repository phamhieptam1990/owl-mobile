import 'package:athena/screens/collections/detail/models/contracNo.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/customer/customer.model.dart';
import 'package:athena/models/kalapa_info_response.dart';
import 'package:athena/models/tickets/recovery_info_repsonse.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/utils.dart';
import '../../common/constants/functionsScreen.dart';
import '../../getit.dart';
import '../../models/customer/contact.new.model.dart';
import '../../models/customer/contractBasic.model.dart';
import '../../models/customer/contractDetail.model.dart';
import '../../models/customer/contractForClosure.model.dart';
import '../../models/customer/contractPaysche.model.dart';
import '../../utils/global-store/user_info_store.dart';
import '../../utils/storage/storage_helper.dart';
import 'collections.service.dart';

class CollectionDetailCaseController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onReady() {
    super.onReady();
    this.handleFirstLayout();
  }

  String contractType = 'Khoản vay tiền mặt';
  String pradd = ""; //Địa chỉ thường trú hộ khẩu
  String tmpadd = ""; // Địa chỉ tạm trú hiện tại
  String office = "";
  String otherAddress = "";
  CustomerModel? customerModel;
  var contractDto;
  TicketModel? ticketModel;
  TicketModel? ticketModelParams;
  ModelBriefByContractNo? briefByContractNo;
  ContactNewModel? contactNewModel;
  ContractBasicModel? contractBasicModel;
  List<ContractPayscheModel>? lstContractPaysche;
  ContractForeclosureModel? contractForColure;
  ContractDetailModel? contractDetailModel;
  bool isLoading = true;
  var pltbAddresses;
  var tenantCode;
  final collectionService = new CollectionService();
  final customerService = new CustomerService();
  TabController? tabController;
  final _userInfoStore = getIt<UserInfoStore>();

  RecoveryInfoData? recoveryInfoData;
  Future<void> handleFirstLayout() async {
    try {
      if (MyConnectivity.instance.isOffline) {
        if(ticketModelParams == null){
          return;
        }
        if (Utils.checkIsNotNull(ticketModelParams?.contractDetail)) {
          contractDto = ticketModelParams?.contractDetail;
        }
        if (Utils.checkIsNotNull(ticketModelParams?.contactDetail)) {
          customerModel =
              CustomerModel.fromJson(ticketModelParams?.contactDetail);
          handleAddressFromContact();
        }
        if (Utils.checkIsNotNull(ticketModelParams?.ticketDetail)) {
          ticketModel = TicketModel.fromJson(ticketModelParams?.ticketDetail);
          ticketModel?.feType = contractDto['feType'] ?? '';
        }
      } else {

        DIO.Response ticketModelDto =
            await collectionService.getTicketDetail(ticketModelParams?.aggId ?? '');
        if (Utils.checkRequestIsComplete(ticketModelDto)) {
          final ticketModelData = Utils.handleRequestData(ticketModelDto);
          if (Utils.checkIsNotNull(ticketModelData)) {
            ticketModel = TicketModel.fromJson(ticketModelData);
            if (!Utils.checkIsNotNull(ticketModelParams?.ticketDetail)) {
              var ticketDetailTemp = ticketModelData;
              if(ticketDetailTemp == null){
                return;
              }
              ticketModel?.actionGroupName = ticketDetailTemp['actionGroupName'];
              ticketModel?.lastEventDate = ticketDetailTemp['lastEventDate'];
              ticketModel?.lastPaymentDate = ticketDetailTemp['lastPaymentDate'];
              ticketModel?.lastPaymentAmount =
                  ticketDetailTemp['lastPaymentAmount'];
              ticketModelParams?.ticketDetail = ticketModelData;
            }
          }
        }
        isLoading = false;
        update(['CollectionDetailCaseController']);
        final String contractId = ticketModelParams?.contractId ?? '';
          if (Utils.checkIsNotNull(contractId)) {
          final DIO.Response rContractDto = await collectionService
              .getContractByAggId(contractId);
          if (Utils.checkRequestIsComplete(rContractDto)) {
            final contractData = Utils.handleRequestData(rContractDto);
            if (Utils.checkIsNotNull(contractData)) {
              contractDto = contractData;
              ticketModelParams?.contractDetail = contractData;
            }
          }
        }
        final String aggIdForContract = ticketModelParams?.aggId ?? '';
          if (aggIdForContract.isNotEmpty) {
          final DIO.Response rContractDto2 = await collectionService
              .getContractByAggIdNew(aggIdForContract);
          if (Utils.checkRequestIsComplete(rContractDto2)) {
            final contractDataNew = Utils.handleRequestData(rContractDto2);
            if (Utils.checkIsNotNull(contractDataNew)) {
              contractDataNew.forEach((key, value) {
                if (Utils.checkIsNotNull(value)) {
                  contractDto[key] = value;
                }
              });
            }
          }
        }

        update(['CollectionDetailCaseController']);

        // final Response rContactDto = await customerService
        //     .getContactByAggId(ticketModelParams.customerId);
        final String aggIdForContact = ticketModelParams?.aggId ?? '';
          if (aggIdForContact.isNotEmpty) {
          final DIO.Response rContactDto =
              await customerService.getContactByAggId(aggIdForContact);
          if (Utils.checkRequestIsComplete(rContactDto)) {
            final contactData = Utils.handleRequestData(rContactDto);
            if (Utils.checkIsNotNull(contactData)) {
              customerModel = CustomerModel.fromJson(contactData);
              ticketModelParams?.contactDetail = contactData;
              handleAddressFromContact();
            }
          }
      
        final DIO.Response contactNewModelTemp =
            await customerService.getContactByAggIdNew(aggIdForContact);
        if (Utils.checkRequestIsComplete(contactNewModelTemp)) {
          final contactNewModelData =
              Utils.handleRequestData(contactNewModelTemp);
          if (Utils.checkIsNotNull(contactNewModelData)) {
            contactNewModel = ContactNewModel.fromJson(contactNewModelData);
          }
        }

        final DIO.Response contractForColu = await collectionService
            .getContractForeclosure(aggIdForContact);
        if (Utils.checkRequestIsComplete(contractForColu)) {
          final contractForColuData = Utils.handleRequestData(contractForColu);
          if (Utils.checkIsNotNull(contractForColuData)) {
            contractForColure =
                ContractForeclosureModel.fromJson(contractForColuData);
          }
        }

        final DIO.Response contractDetail = await collectionService
            .getContractByAggid(aggIdForContact);
        if (Utils.checkRequestIsComplete(contractDetail)) {
          final contractDetailData = Utils.handleRequestData(contractDetail);
          if (Utils.checkIsNotNull(contractDetailData)) {
            contractDetailModel =
                ContractDetailModel.fromJson(contractDetailData);
          }
        }

        final DIO.Response contractBasic = await collectionService
            .getContractBasicByAggId(aggIdForContact);
        if (Utils.checkRequestIsComplete(contractBasic)) {
          final contractBasicData = Utils.handleRequestData(contractBasic);
          if (Utils.checkIsNotNull(contractBasicData)) {
            contractBasicModel = ContractBasicModel.fromJson(contractBasicData);
          }
        }
        lstContractPaysche = [];
        tenantCode =
            await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE);
        if (tenantCode == 'TNEX') {
          final DIO.Response contractPaysche = await collectionService
              .contractPayschepivotPaging(aggIdForContact);
          if (Utils.checkRequestIsComplete(contractPaysche)) {
            final lstData = Utils.handleRequestData2Level(contractPaysche);
            if (Utils.isArray(lstData)) {
              for (var data in lstData) {
                lstContractPaysche?.add(ContractPayscheModel.fromJson(data));
              }
            }
          }
        }

        // update(['CollectionDetailCaseController']);

        // if (_userInfoStore.checkPerimission(ScreenPermission.RECOVERY_FIELD)) {
        //   final recoveryInfoResponse = await collectionService.getRecoveryInfo(
        //       ticketModel.feType ?? '',
        //       accountNumber: ticketModel.contractId,
        //       applId: contractDto['applId']);
        //   final recovery =
        //       RecoveryInfoResponse.fromJson(recoveryInfoResponse.data);
        //   if ((recovery.data.isNotEmpty ?? false)) {
        //     recoveryInfoData = recovery.data.first;
        //   }
        //         }

        // update(['CollectionDetailCaseController']);
      }
      }
    } catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
      if (!MyConnectivity.instance.isOffline) {
        if (ticketModelParams != null) {
          HiveDBService.updateCollections(ticketModelParams!);
        } else {
          print(
              "⚠️ ticketModelParams is null, không thể gọi updateCollections.");
          // Có thể hiển thị snackbar / dialog thông báo lỗi cho người dùng
        }
      }
      update(['CollectionDetailCaseController']);
    }
  }

  void handleAddressFromContact() {
    if (Utils.isArray(customerModel?.pltbAddresses)) {
      pltbAddresses = customerModel?.pltbAddresses;
      for (var address in pltbAddresses) {
        var addressType = address['addressType'];
        if (addressType != null) {
          if (addressType['typeCode'] == "PRADD") {
            pradd = address['formattedAddress'];
          } else if (addressType['typeCode'] == "TMPADD") {
            tmpadd = address['formattedAddress'];
          } else if (addressType['typeCode'] == "OFFICE") {
            office = address['formattedAddress'];
          } else if (addressType['typeCode'] == "OTHER") {
            otherAddress = address['formattedAddress'];
          }
        }
      }
    }
  }

  String returnData(var data, {String type = '', String field = ''}) {
    if (data == 'null') {
      return '';
    }
    if(data == null){
      return '';
    }
    if (type == 'money') {
      if (field == 'totalChargesOverdue') {
        return Utils.checkIsNull(data) ? data.ceil().toString() : '';
      }
      return Utils.checkIsNull(data) ? data.round().toString() : '';
    }
    return Utils.checkIsNull(data) ? data.toString() : '';
  }

  String showValueByType() {
    if (ticketModelParams?.feType == ActionPhone.LOAN) {
      return Utils.formatPrice(
          returnData(contractDto['securityDeposit'], type: 'money'));
    }
    if (ticketModelParams?.feType == ActionPhone.CARD) {
      return Utils.formatPrice(
          returnData(contractDto['minAmountDue'], type: 'money'));
    }
    return '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
  }

  // Future<DebtSettlementResponse> debtSettlementData() async {
  //   try {
  //     final _repsonse = await collectionService
  //         .getDebtSettlement(ticketModelParams?.contractDetail['appId']);
  //     final response = DebtSettlementResponse.fromJson(_repsonse?.data);
  //     return response;
  //   } catch (err) {
  //     return null;
  //   }
  // }
}
