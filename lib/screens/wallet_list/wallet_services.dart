import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/models/wallet_list/all_by_emp_code_response.dart';
import 'package:athena/utils/log/crashlystic_services.dart';

import '../../common/constants/wallet_constant_path.dart';
import '../../utils/http/http_helper.dart';

class WalletLinkingServices {
  bool isLoged = false;

  static Future<Response?> getAllByEmpCode() async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['GET_OVERALL_BY_EMP_CODE'];
      if (endpoint == null) {
        debugPrint('Endpoint GET_OVERALL_BY_EMP_CODE is null');
        return null;
      }
      return await HttpHelper.get(endpoint);
    } catch (e) {
      CrashlysticServices.instance.log('Error in getAllByEmpCode: $e');
      return null;
    }
  }

  static Future<Response?> getListProviderByMethodCode(
      {String method = 'EWALLET'}) async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['LIST_PROVIDER_BY_METHOD_CODE'];
      if (endpoint == null) {
        debugPrint('Endpoint LIST_PROVIDER_BY_METHOD_CODE is null');
        return null;
      }
      return await HttpHelper.get(endpoint + method);
    } catch (e) {
      CrashlysticServices.instance.log('Error in getListProviderByMethodCode: $e');
      return null;
    }
  }

  static Future<Response?> updateStatusLinking(AllByEmpCodeData data) async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['QUERY_LINK_PAYMENT_EWALLET'];
      if (endpoint == null) {
        debugPrint('Endpoint QUERY_LINK_PAYMENT_EWALLET is null');
        return null;
      }
      
      final body = {'aggId': data.aggId};
      return await HttpHelper.postJSON(endpoint, body: body);
    } catch (e) {
      CrashlysticServices.instance.log('Error in updateStatusLinking: $e');
      return null;
    }
  }

  static Future<Response?> unLinkSMP(AllByEmpCodeData data) async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['UNLINK_PAYMENT_EWALLET'];
      if (endpoint == null) {
        debugPrint('Endpoint UNLINK_PAYMENT_EWALLET is null');
        return null;
      }
      
      final body = {'aggId': data.aggId};
      return await HttpHelper.postJSON(endpoint, body: body);
    } catch (e) {
      CrashlysticServices.instance.log('Error in unLinkSMP: $e');
      return null;
    }
  }

  static Future<Response?> linkPaymentEwalletSMP(AllByEmpCodeData data) async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['LINK_PAYMENT_EWALLET'];
      if (endpoint == null) {
        debugPrint('Endpoint LINK_PAYMENT_EWALLET is null');
        return null;
      }
      
      final appUrl = _getCallBackUrl();
      final body = {
        'cmd': {
          'callbackUrl': appUrl,
          'providerNo': data.providerCode,
          'paymentMethodCode': data.methodCode
        }
      };
      return await HttpHelper.postJSON(endpoint, body: body);
    } catch (e) {
      CrashlysticServices.instance.log('Error in linkPaymentEwalletSMP: $e');
      return null;
    }
  }

  static String _getCallBackUrl() {
    if (Platform.isIOS) {
      return IS_PRODUCTION_APP
          ? WalletPathConstant.callBackUrlSMPProdIOS
          : WalletPathConstant.callBackUrlSMPUatIOS;
    } else {
      return IS_PRODUCTION_APP
          ? WalletPathConstant.callBackUrlSMPProdAndroid
          : WalletPathConstant.callBackUrlSMPUatAndroid;
    }
  }

  static Future<Response?> getOverallByEmpCodeWithBalance() async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['GET_OVERRLL_BY_EMP_CODE_WITH_BALANCE'];
      if (endpoint == null) {
        debugPrint('Endpoint GET_OVERRLL_BY_EMP_CODE_WITH_BALANCE is null');
        return null;
      }
      return await HttpHelper.postJSON(endpoint);
    } catch (e) {
      CrashlysticServices.instance.log('Error in getOverallByEmpCodeWithBalance: $e');
      return null;
    }
  }

  static Future<Response?> getByContractId(String contractId) async {
    try {
      final endpoint = SERVICE_URL.MCRSMP['GET_WALLET_TRANSACTION'];
      if (endpoint == null) {
        debugPrint('Endpoint GET_WALLET_TRANSACTION is null');
        return null;
      }
      
      final query = '?contractId=$contractId';
      return await HttpHelper.get(endpoint + query);
    } catch (e) {
      CrashlysticServices.instance.log('Error in getByContractId: $e');
      return null;
    }
  }
}