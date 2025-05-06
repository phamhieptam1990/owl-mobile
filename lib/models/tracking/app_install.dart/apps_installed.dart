import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'apps_installed.g.dart';

AppsInstalled appsInstalledFromJson(String str) =>
    AppsInstalled.fromJson(json.decode(str) as Map<String, dynamic>);

String appsInstalledToJson(AppsInstalled data) => json.encode(data.toJson());

@HiveType(typeId: 12)
class AppsInstalled extends HiveObject {
  AppsInstalled({
    this.excuteTinme,
    this.recordType,
    this.appsInstalled,
  });
  
  @HiveField(0)
  String? excuteTinme;

  @HiveField(1)
  String? recordType;

  @HiveField(2)
  List<AppsInstalledElement>? appsInstalled;

  factory AppsInstalled.fromJson(Map<String, dynamic> json) => AppsInstalled(
        excuteTinme: json["excuteTinme"] as String?,
        recordType: json["recordType"] as String?,
        appsInstalled: json["appsInstalled"] != null
            ? List<AppsInstalledElement>.from(
                (json["appsInstalled"] as List).map(
                  (x) => AppsInstalledElement.fromJson(x as Map<String, dynamic>),
                ),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        "excuteTinme": excuteTinme,
        "recordType": recordType,
        "appsInstalled": appsInstalled != null
            ? List<dynamic>.from((appsInstalled??[]).map((x) => x.toJson()))
            : null,
      };
}

@HiveType(typeId: 13)
class AppsInstalledElement {
  AppsInstalledElement({
    this.appName,
    this.packageName,
    this.versionName,
    this.installTimeMillis,
  });
  
  @HiveField(0)
  String? appName;

  @HiveField(1)
  String? packageName;

  @HiveField(2)
  String? versionName;

  @HiveField(3)
  int? installTimeMillis;

  String get installDate => _timestampToString(installTimeMillis);

  String _timestampToString(int? value) {
    try {
      if (value == null) return '';
      final _date = DateTime.fromMillisecondsSinceEpoch(value);
      return DateFormat('dd/MM/yyyy hh:mm').format(_date);
    } catch (_) {
      return '';
    }
  }

  factory AppsInstalledElement.fromJson(Map<String, dynamic> json) =>
      AppsInstalledElement(
        appName: json["appName"] as String?,
        packageName: json["packageName"] as String?,
        versionName: json["versionName"] as String?,
        installTimeMillis: json["installTimeMillis"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "appName": appName,
        "packageName": packageName,
        "versionName": versionName,
        "installedDate": installDate,
      };
}