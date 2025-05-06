import 'package:hive/hive.dart';
part 'activity.offline.model.g.dart';

@HiveType(typeId: 6)
class ActivityOfflineModel {
  @HiveField(0)
  String? published;
  @HiveField(1)
  String? summary;
  @HiveField(2)
  String? appCode;
  @HiveField(3)
  String? tenantCode;
  @HiveField(4)
  String? action;
  @HiveField(5)
  dynamic actor;
  @HiveField(6)
  dynamic target;
  @HiveField(7)
  dynamic object;
  ActivityOfflineModel({
    this.published,
    this.summary,
    this.appCode,
    this.tenantCode,
    this.action,
    this.actor,
    this.target,
    this.object,
  });
}
