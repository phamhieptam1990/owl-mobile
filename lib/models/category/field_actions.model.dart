class FieldActions {
  int? orderNo;
  String? authStatus;
  FetmAction? fetmAction;
  int? modNo;
  String? recordStatus;
  int? contactPersonId;
  int? actionGroupId;
  int? actionId;
  int? id;
  String? makerId;

  FieldActions({
    this.orderNo,
    this.authStatus,
    this.fetmAction,
    this.modNo,
    this.recordStatus,
    this.contactPersonId,
    this.actionGroupId,
    this.actionId,
    this.id,
    this.makerId,
  });

  FieldActions.fromJson(Map<dynamic, dynamic> json) {
    orderNo = json['orderNo'];
    authStatus = json['authStatus'];
    fetmAction = json['fetmAction'] != null
        ? FetmAction.fromJson(json['fetmAction'])
        : null;
    modNo = json['modNo'];
    recordStatus = json['recordStatus'];
    contactPersonId = json['contactPersonId'];
    actionGroupId = json['actionGroupId'];
    actionId = json['actionId'];
    id = json['id'];
    makerId = json['makerId'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['orderNo'] = orderNo;
    data['authStatus'] = authStatus;
    if (fetmAction != null) {
      data['fetmAction'] = fetmAction?.toJson();
    }
    data['modNo'] = modNo;
    data['recordStatus'] = recordStatus;
    data['contactPersonId'] = contactPersonId;
    data['actionGroupId'] = actionGroupId;
    data['actionId'] = actionId;
    data['id'] = id;
    data['makerId'] = makerId;
    return data;
  }
}

class FetmAction {
  int? orderNo;
  String? actionValue;
  String? authStatus;
  int? modNo;
  String? recordStatus;
  String? actionCode;
  int? id;
  String? actionName;
  String? makerId;

  FetmAction({
    this.orderNo,
    this.actionValue,
    this.authStatus,
    this.modNo,
    this.recordStatus,
    this.actionCode,
    this.id,
    this.actionName,
    this.makerId,
  });

  FetmAction.fromJson(Map<dynamic, dynamic> json) {
    orderNo = json['orderNo'];
    actionValue = json['actionValue'];
    authStatus = json['authStatus'];
    modNo = json['modNo'];
    recordStatus = json['recordStatus'];
    actionCode = json['actionCode'];
    id = json['id'];
    actionName = json['actionName'];
    makerId = json['makerId'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['orderNo'] = orderNo;
    data['actionValue'] = actionValue;
    data['authStatus'] = authStatus;
    data['modNo'] = modNo;
    data['recordStatus'] = recordStatus;
    data['actionCode'] = actionCode;
    data['id'] = id;
    data['actionName'] = actionName;
    data['makerId'] = makerId;
    return data;
  }
}