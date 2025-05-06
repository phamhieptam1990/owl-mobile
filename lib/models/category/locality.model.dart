import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class LocalityModel extends Equatable {
  String? code;
  int? localityTypeId;
  String? name;
  int? id;
  int? parentId;
  
  LocalityModel({
    this.code, 
    this.localityTypeId, 
    this.name, 
    this.id, 
    this.parentId
  });

  factory LocalityModel.fromJson(Map<dynamic, dynamic> json) {
    return LocalityModel(
        code: json['code'],
        localityTypeId: json['localityTypeId'],
        name: json['name'],
        id: json['id'],
        parentId: json['parentId']);
  }

  // factory LocalityModel.fromJson(Map<String, dynamic> json) {
  //   code = json['code'];
  //   localityTypeId = json['localityTypeId'];
  //   name = json['name'];
  //   id = json['id'];
  //   parentId = json['parentId'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['localityTypeId'] = this.localityTypeId;
  //   data['name'] = this.name;
  //   data['id'] = this.id;
  //   data['parentId'] = this.parentId;
  //   return data;
  // }

  Map<String, dynamic> toJson() => {
        'code': code,
        'localityTypeId': localityTypeId,
        'name': name,
        'id': id,
        'parentId': parentId,
      };

  @override
  List<Object?> get props => [code, localityTypeId, name];
}