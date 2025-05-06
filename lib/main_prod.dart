import 'config/enviroment/app_url.dart';
import 'config/enviroment/enviroment_type.dart';
import 'config/enviroment/environment.dart';
import 'flavor_config.dart';
import 'my_app.dart';

Future<void> main() async {
    FlavorConfig.appFlavor = Flavor.prod; 
  Environment.appEnvironment = Production(); // Set môi trường trước
  await MyApp.run(Flavor.prod); // Gọi hàm async đã được refactor
}

class Production extends Environment {
  @override
  EnvironmentType get environmentType => EnvironmentType.production;

  @override
  bool get enableLogger => false;

  @override
  String get hostNameServices => AppUrl.productionHostNameServices;

  @override
  String get hostNameVNG => AppUrl.hostNameVNG;

  @override
  String get hostNameApi => AppUrl.productionHostNameApi;

  @override
  String get hostName => AppUrl.productionHostName;

  @override
  String get hostChatApi => AppUrl.productionHostName;

  @override
  String get appTitle => AppUrl.prodAppTitle;

  @override
  String get sentryEviroment => AppUrl.sentryEnviromentProd;
}
