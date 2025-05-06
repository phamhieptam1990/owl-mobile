import 'package:get/get.dart';
import 'package:athena/screens/collections/collection/history_payment_card_response.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/history_transaction_card/models/history_transaction_complain_response.dart';
import 'package:athena/utils/utils.dart';

import '../../../models/tickets/ticket.model.dart';
import 'history_transaction_card_service.dart';

class HistoryTransactionCardController extends GetxController {
  HistoryTransactionComplainData? data;
  String contractId;

  bool isLoading = false;
  bool enablePullUp = false;
  HistoryTransactionCardController(this.ticketModel)
      : contractId = ticketModel.contractId ?? '';
  List<Transaction> cardTransaction = [];
  List<Transaction> rechargeTransaction = [];
  final TicketModel ticketModel;

  int? joinDate;

  int fromDateInput = 0;
  int toDateInput = 0;

  int? maxDate;

  DateTime? maxTimeInput;

  bool isShowFilter = false;

  @override
  void onInit() {
    if (ticketModel.contactDetail != null) {
      joinDate = ticketModel.contactDetail['joinDate'] != null
          ? ticketModel.contactDetail['joinDate']
          : null;
    }

    super.onInit();
  }

  @override
  void onReady() {
    fetchData();

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    try {
      final response =
          await HistoryTransactionCardService().getHistories(this.contractId);
        if (response?.data == null) {
        throw Exception("No data available");
      }
      
      data = response?.data!;
      // converList();
      _handleDate();

      await fetchAllTransaction(fromDateInput, toDateInput);
          isLoading = false;
      isShowFilter = true;
      update();
    } catch (e) {
      isLoading = false;

      update();
    }
  }

  void _handleDate() {
    try {
      // Fix 12: Add null checking for nested fields and use null coalescing
      if (data?.cardSecInfoType?.cardStatements?.cardStatement?.isEmpty ??
          true) {

        fromDateInput = DateTime.now().millisecondsSinceEpoch;
        toDateInput = DateTime.now().millisecondsSinceEpoch;
        return;
      }
      
      // Fix 13: Use null coalescing for nested access
      int lastStateDate = (data?.cardSecInfoType?.cardStatements?.cardStatement!
                  .last.statementdate ??
              DateTime.now().millisecondsSinceEpoch) -
          (100 * 86400000);
          
      fromDateInput = joinDate ?? lastStateDate;
      
      // Fix 14: Safe access to first element
      toDateInput = data?.cardSecInfoType?.cardStatements?.cardStatement!
              .first.statementdate ??
          DateTime.now().millisecondsSinceEpoch;

      // Fix 15: Safely calculate maxTimeInput
      maxTimeInput = _converTimeStampToDate(
              data?.cardSecInfoType?.cardStatements?.cardStatement!
                  .first.statementdate ??
                  DateTime.now().millisecondsSinceEpoch)
          .add(const Duration(days: 30));

      maxDate = joinDate ?? lastStateDate;
    } catch (e) {
      print('Error in _handleDate: $e');
      // Fallback values for error case
      fromDateInput = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;
      toDateInput = DateTime.now().millisecondsSinceEpoch;
    }
  }

//with last statement add more 31 days to get full transaction
  Future<void> fetchAllTransaction(int fromDateInput, int toDateInput) async {
   try {
      // Fix 16: Handle response data properly
      final responseTemp = await CollectionService().getTransactionCardList(
          fromDate: fromDateInput,
          toDate: toDateInput,
          accountNumber: contractId,
          transType: 1);
          
      // Fix 17: Add null check for nested access
      if (responseTemp.data != null && responseTemp.data['data'] != null) {
        final response =
            HistoryPaymentCardData.fromJson(responseTemp.data['data']);
            
        // Fix 18: Safely assign to cardTransaction
        cardTransaction = response.transactions?.transaction ?? [];
      }

      // Fix 19: Similar fixes for rechargeTransaction
      final responseTemp2 = await CollectionService().getTransactionCardList(
          fromDate: fromDateInput,
          toDate: toDateInput,
          accountNumber: contractId,
          transType: 2);
          
      if (responseTemp2.data != null && responseTemp2.data['data'] != null) {
        final rechargeResponse =
            HistoryPaymentCardData.fromJson(responseTemp2.data['data']);
        rechargeTransaction = rechargeResponse.transactions?.transaction ?? [];
      }
    } catch (e) {
      print('Error in fetchAllTransaction: $e');
      // Initialize to empty lists in case of error
      cardTransaction = [];
      rechargeTransaction = [];
    }
  }

  bool isBetweenTimeStamp(
      int timestame, CardStatementElement begin, CardStatementElement end) {
    try {
      //86400000miliseconds  is +1 day
      if (timestame > (begin.statementdate! + 86400000) &&
          timestame <= (end.statementdate! + 86400000)) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  DateTime _converTimeStampToDate(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timeStamp,
      isUtc: true,
    );
  }

  void onFilter(int fromDate, int toDate) async {
    fromDateInput = fromDate;
    toDateInput = toDate;
    isLoading = true;

    update();
    await fetchAllTransaction(fromDateInput, toDateInput);
    isLoading = false;
    update();
  }

  String getCurrentFilter() {
    try {
      return Utils.convertTimeWithoutTime(fromDateInput) +
          ' - ' +
          Utils.convertTimeWithoutTime(toDateInput);
    } catch (_) {
      return '';
    }
  }
}
