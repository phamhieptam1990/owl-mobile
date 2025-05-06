import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity {
  MyConnectivity._internal();
  static final MyConnectivity _instance = MyConnectivity._internal();
  static MyConnectivity get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  final StreamController<Map<ConnectivityResult, bool>> _controller =
      StreamController.broadcast();
  Stream<Map<ConnectivityResult, bool>> get myStream => _controller.stream;

  bool isShow = false;
  bool isOffline = false;

  Future<void> initialise() async {
    try {
      final List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      await _checkStatus(results);

      _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        _checkStatus(results);
      });
    } catch (e) {
      // Log lỗi nếu cần
    }
  }

  Future<void> _checkStatus(List<ConnectivityResult> results) async {
    // Mặc định là offline, trừ khi có ít nhất 1 loại kết nối hợp lệ
    bool isOnline = results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);

    // Gửi trạng thái của kết nối đầu tiên trong danh sách (hoặc none nếu rỗng)
    _controller.sink.add({
      results.isNotEmpty ? results.first : ConnectivityResult.none: isOnline
    });

    isOffline = !isOnline;
  }

  bool isIssue(Map<ConnectivityResult, bool> onData) =>
      onData.keys.first == ConnectivityResult.none;

  void disposeStream() => _controller.close();
}
