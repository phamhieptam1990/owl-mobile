import 'enviroment_type.dart';

class Environment {
  static late Environment appEnvironment; // 👈 THÊM DÒNG NÀY
  static late Environment value;
  late String hostName;
  late String hostNameVNG;
  late String appTitle;
  EnvironmentType environmentType = EnvironmentType.uat;
  late String hostNameServices;
  late String hostNameApi;
  late String hostChatApi;

  late String sentryEviroment;

  bool enableLogger = false;

  void start() {}
  
  Environment() {
    value = this;
  }
}