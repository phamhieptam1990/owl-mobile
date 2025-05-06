class ActivityModel {
  String? published;
  String? summary;
  String? appCode;
  String? tenantCode;
  String? action;
  dynamic actor;
  dynamic target;
  dynamic object;
  ActivityModel({
    this.published,
    this.summary,
    this.appCode,
    this.tenantCode,
    this.action,
    this.actor,
    this.target,
    this.object,
  });
  Map toJson() => {
        'published': published,
        'summary': summary,
        'appCode': appCode,
        'tenantCode': tenantCode,
        'actor': actor,
        'action': action,
        'target': target,
        'object': object
      };
  factory ActivityModel.fromJson(Map<String, dynamic> activityModel) {
    return ActivityModel(
        published: activityModel['published'],
        summary: activityModel['summary'].toString(),
        appCode: activityModel['appCode'].toString(),
        action: activityModel['action'].toString(),
        tenantCode: activityModel['tenantCode'].toString(),
        actor: activityModel['actor'],
        target: activityModel['target'],
        object: activityModel['object']);
  }
}

class ActorModel {
  String? userCode;
  String? username;
  String? displayName;
  ActorModel({
    this.userCode,
    this.username,
    this.displayName,
  });
}
