
import 'config/enviroment/app_url.dart';
import 'config/enviroment/enviroment_type.dart';
import 'config/enviroment/environment.dart';
import 'flavor_config.dart';
import 'my_app.dart';

Future<void> main() async {
  FlavorConfig.appFlavor = Flavor.uat; 
  Environment.appEnvironment = Uat(); // ✅ Khởi tạo biến static
   await MyApp.run(FlavorConfig.appFlavor); // ✅ Gọi hàm khởi động ứng dụng
}

/// Call api via sandbox url
class Uat extends Environment {
  @override
  EnvironmentType get environmentType => EnvironmentType.uat;

  @override
  bool get enableLogger => false;

  @override
  String get hostNameServices => AppUrl.uatHostNameServices;

  @override
  String get hostNameVNG => AppUrl.uatHostNameVNG;

  @override
  String get hostNameApi => AppUrl.uatHostNameApi;

  @override
  String get hostName => AppUrl.uatHostName;

  @override
  String get hostChatApi => AppUrl.uatHostChatApi;

  @override
  String get appTitle => AppUrl.uatAppTitle;

  @override
  String get sentryEviroment => AppUrl.sentryEnviromentUat;
}
