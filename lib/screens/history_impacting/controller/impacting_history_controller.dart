import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:athena/screens/history_impacting/models/action_code_response.dart';
import 'package:athena/screens/history_impacting/models/impacting_history_response.dart';

import '../../../common/config/app_config.dart';
import '../../../models/tickets/ticket.model.dart';
import '../../../utils/http/http_helper.dart';
import '../../../utils/log/crashlystic_services.dart';
import '../models/impacting_filter_models.dart';

class ImpactingHistoryController extends GetxController {
  final TicketModel _ticketModel;

  ImpactingHistoryController(this._ticketModel);
  ImpactingFilterModels currentImpactingFilterModels = ImpactingFilterModels(
    sortField: 'createDate',
    sortDirection: 'desc',
  );

  List<ActionCodeItem> actionCodeList = [
    ActionCodeItem(code: 'all', name: 'Tất cả', actionId: -1)
  ];
  List<ImpactingHistoryItem> impactingHistorys = [];
  bool isLoading = false;

  ActionCodeItem currentChossed =
      ActionCodeItem(code: 'all', name: 'Tất cả', actionId: -1);

  List<ActionCodeItem>? actionCodesServer;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getData() async {
    try {
      isLoading = true;
      update();
      
      // Fix 6: Handle nullable return from getActionCode()
      final codes = await getActionCode();
      actionCodesServer = codes;
      
      // Fix 7: Add null check before addAll()
      if (codes.isNotEmpty) {
        actionCodeList.addAll(codes);
      }
      
      // Fix 8: Safely access contractId with null check
      final contractId = _ticketModel.contractId ?? '';
      impactingHistorys = await getImpactingHistory(
        contractId,
        filterData: currentImpactingFilterModels
      );
      
      isLoading = false;
      update();
    } catch (e) {
      print('Error in getData: $e');
      isLoading = false;
      update();
    }
  }

  void onFilter() async {
    try {
      isLoading = true;
      update();
      
      // Fix 9: Use null-safe property access with ?.
      currentImpactingFilterModels.actionCode = currentChossed.code;
      
      // Fix 10: Safely access contractId with null check
      final contractId = _ticketModel.contractId ?? '';
      impactingHistorys = await getImpactingHistory(
        contractId,
        filterData: currentImpactingFilterModels
      );
      
      isLoading = false;
      update();
    } catch (e) {
      print('Error in onFilter: $e');
      isLoading = false;
      update();
    }
  }

  Future<List<ImpactingHistoryItem>> getImpactingHistory(String contractId,
      {ImpactingFilterModels? filterData}) async {
    try {
      // List<String> _actionCodesQuery;
      // //mark all query
      // if (currentChossed.actionId == -1) {
      //   _actionCodesQuery = actionCodesServer?.map((e) => e.code)?.toList();
      // } else {
      //   _actionCodesQuery = [currentChossed?.code];
      // }

      // Map<String, dynamic> _body = {
      //   'contractId': contractId,
      //   'actionCode': _actionCodesQuery,
      //   'offset': 0,
      //   'limit': 100,
      // };

      // final response = await HttpHelper.postJSON(
      //     SERVICE_URL.MCROPS['GET_BIX_FECA_FOLLOWUP'],
      //     body: _body);
      // final impactingHisToryResponse =
      //     ImpactingHistoryResponse.fromJson(response?.data);
      // if (response?.statusCode == 200 &&
      //     impactingHisToryResponse?.status == 0) {
      //   return impactingHisToryResponse?.data ?? [];
      // } else {
      //   return [];
      // }
      return [];
    } catch (e) {
      CrashlysticServices.instance.log(e.toString());
      return [];
    }
  }

  Future<List<ActionCodeItem>> getActionCode() async {
    try {
      final response =
          await HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_ACTION_CODE);
      final actionCodeResponse = ActionCodeResponse.fromJson(response.data);

      if (response.statusCode == 200 && actionCodeResponse.status == 0) {
        return actionCodeResponse.data ?? [];
      } else {
        return [];
      }
    } catch (msg) {
      CrashlysticServices.instance.log(msg.toString());
      return <ActionCodeItem>[];
    }
  }
}
