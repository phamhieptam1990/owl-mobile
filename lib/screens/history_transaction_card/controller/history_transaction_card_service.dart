import 'package:athena/common/config/app_config.dart';
import 'package:athena/screens/history_transaction_card/models/history_transaction_complain_response.dart';
import 'package:athena/utils/http/http_helper.dart';

class HistoryTransactionCardService {
  Future<HistoryTransactionComplainResponse?> getHistories(
      String accountNumber) async {
    try {
      final response = await HttpHelper.get(
        MCR_FEA_URL.HISTORY_TRANSACTION_CARD +
            '?accountNumber=' +
            accountNumber,
      );

      return HistoryTransactionComplainResponse?.fromJson(response.data);
    } catch (_) {
      print(_.toString());
      return null;
    }
  }
}
