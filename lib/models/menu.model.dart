import 'package:athena/utils/http/base_response.dart';

class MenuAppModel extends BaseObject<MenuAppModel> {
  int? id;
  String? menuName;
  String? menuCode;
  int? menuOrder;
  int? parentId;
  String? urlPropertyName;
  String? moduleName;
  dynamic menuType;
  dynamic menuPublic;
  dynamic historyToken;
  List<MenuAppModel>? children;

  MenuAppModel(
      {this.id,
      this.menuName,
      this.menuCode,
      this.menuOrder,
      this.parentId,
      this.urlPropertyName,
      this.moduleName,
      this.menuType,
      this.menuPublic,
      this.historyToken,
      this.children});

  MenuAppModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menuName'];
    menuCode = json['menuCode'];
    menuOrder = json['menuOrder'];
    parentId = json['parentId'];
    urlPropertyName = json['urlPropertyName'];
    moduleName = json['moduleName'];
    menuType = json['menuType'];
    menuPublic = json['menuPublic'];
    historyToken = json['historyToken'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(new MenuAppModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuName'] = this.menuName;
    data['menuCode'] = this.menuCode;
    data['menuOrder'] = this.menuOrder;
    data['parentId'] = this.parentId;
    data['urlPropertyName'] = this.urlPropertyName;
    data['moduleName'] = this.moduleName;
    data['menuType'] = this.menuType;
    data['menuPublic'] = this.menuPublic;
    data['historyToken'] = this.historyToken;
    data['children'] = this.children?.map((v) => v.toJson()).toList();
      return data;
  }

  @override
  MenuAppModel fromJson(json) {
    return MenuAppModel.fromJson(json);
  }
}
