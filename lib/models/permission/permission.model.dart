class PermissionModel {
  String? target;
  String? action;

  PermissionModel({this.target, this.action});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['action'] = this.action;
    return data;
  }
}
