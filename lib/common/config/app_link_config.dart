// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uni_links/uni_links.dart';

// import '../../models/events.dart';
// import '../../models/wallet_list/query_link_payment_ewallet_response.dart';
// import '../../screens/wallet_list/wallet_list_controller.dart';
// import '../../screens/wallet_list/wallet_services.dart';
// import '../../utils/log/crashlystic_services.dart';
// import '../../utils/navigation/navigation.service.dart';
// import '../../utils/storage/storage_helper.dart';
// import '../../widgets/app_loading_widget.dart';
// import '../constants/color.dart';
// import '../constants/general.dart';
// import '../constants/wallet_constant_path.dart';

// class AppLinkConfig {
//   static bool initialUriIsHandled = false;
//   StreamSubscription<Uri?>? _sub;

//   AppLinkConfig._();

//   static final AppLinkConfig _instance = AppLinkConfig._();
//   static AppLinkConfig get instance => _instance;

//   factory AppLinkConfig() {
//     return _instance;
//   }

//   static Future<void> handleInitialUri() async {
//     if (!initialUriIsHandled) {
//       initialUriIsHandled = true;
//       try {
//         final uri = await getInitialUri();
//         if (uri == null) {
//           print('no initial uri');
//         } else {
//           print('got initial uri: $uri');
//         }
//       } on PlatformException {
//         print('falied to get initial uri');
//       } on FormatException catch (err) {
//         print('malformed initial uri $err');
//       }
//     }
//   }

//   void handleIncomingLinks() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri == null || uri.path.isEmpty) {
//         return;
//       } else {
//         final _resultSplitUri = _parseUriToList(uri.path);
//         WalletType _walletType = getWalletType(_resultSplitUri);
//         _handlWalletType(_walletType, uri.toString());
//       }
//     }, onError: (Object err) {
//       // Handle error
//     });
//   }

//   static List<String> _parseUriToList(String url, {String symbol = '/'}) {
//     try {
//       return url.split('$symbol');
//     } catch (_) {
//       return [];
//     }
//   }

//   WalletType getWalletType(List<String> stringList) {
//     if (stringList.isEmpty) {
//       return WalletType.unknows;
//     } else {
//       final lastString = stringList.last;

//       switch ('/' + lastString) {
//         case WalletPathConstant.smartPay:
//           return WalletType.smartPay;
//         default:
//           return WalletType.unknows;
//       }
//     }
//   }

//   void _handlWalletType(WalletType type, String clickedLink) {
//     switch (type) {
//       case WalletType.smartPay:
//         _smartPaylinkingIncoming(clickedLink);
//         break;
//       default:
//         _unKnownType();
//     }
//   }

//   //Unknow linking type
//   void _unKnownType() {
//     print('_unKnownType');
//   }

//   void _smartPaylinkingIncoming(String clickedLink) async {
//     try {
//       final isLogged = await _isLogged();
//       if (isLogged) {
//         print('        eventBus.fire(QueryStatusLinkingSMP(clickedLink))');
//         AppLoading.show();
//         final response = await WalletLinkingServices.updateStatusLinking(
//             WalletListController.currentLinkingData!);

//         if (response != null) {
//           final statusLinkingResponse =
//               QueryLinkPaymentEwalletResponse.fromJson(response.data);
//           if (statusLinkingResponse.data == 'S') {
//             showSucess(title: 'Liên kết thành công');
//           } else {
//             showFailed(title: 'Liên kết thất bại');
//           }
//         } else {
//           showFailed(title: 'Không thể kết nối');
//         }
//         AppLoading.dismiss();
//         eventBus.fire(QueryStatusLinkingSMP());
//       } else {
//         print('not logged in');
//       }
//     } catch (erros) {
//       print(erros);
//       CrashlysticServices.instance.log(erros.toString());
//   }
//   }

//   void showFailed({String title = 'Làm mới thất bại!'}) {
//     final snackbar = SnackBar(
//       content: Text(title),
//       duration: Duration(seconds: 2),
//       backgroundColor: Colors.redAccent,
//     );
    
//     final context = NavigationService.instance.navigationKey.currentContext;
//     if (context != null) {
//       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//     }
//   }

//   void showSucess({String title = 'Làm mới thành công'}) {
//     final snackbar = SnackBar(
//       content: Text(title),
//       duration: Duration(seconds: 2),
//       backgroundColor: AppColor.primary,
//     );
    
//     final context = NavigationService.instance.navigationKey.currentContext;
//     if (context != null) {
//       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//     }
//   }
// }

// Future<bool> _isLogged() async {
//   try {
//     String? _isLogged =
//         await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
//     return _isLogged != null;
//   } catch (_) {
//     return false;
//   }
// }

// enum WalletType { smartPay, unknows }