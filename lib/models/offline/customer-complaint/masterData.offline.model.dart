import 'package:hive/hive.dart';
part 'masterData.offline.model.g.dart';

@HiveType(typeId: 3)
class MasterDataComplainOfflineModel {
  @HiveField(0)
  String? attributeValue;
  @HiveField(1)
  String? categoryCode;
  @HiveField(2)
  String? categoryName;
  @HiveField(3)
  String? productName;
  @HiveField(4)
  String? casetypeName;
  @HiveField(5)
  String? attributeCode;
  @HiveField(6)
  String? subcategoryName;
  @HiveField(7)
  String? productCode;
  @HiveField(8)
  String? productValue;
  @HiveField(9)
  String? subcategoryValue;
  @HiveField(10)
  String? casetypeCode;
  @HiveField(11)
  String? categoryValue;
  @HiveField(12)
  String? casetypeValue;
  @HiveField(13)
  String? attributeName;
  @HiveField(14)
  String? subcategoryCode;
  MasterDataComplainOfflineModel(
      {this.attributeValue,
      this.categoryCode,
      this.categoryName,
      this.productName,
      this.casetypeName,
      this.attributeCode,
      this.subcategoryName,
      this.productCode,
      this.productValue,
      this.subcategoryValue,
      this.casetypeCode,
      this.categoryValue,
      this.casetypeValue,
      this.attributeName,
      this.subcategoryCode});

  MasterDataComplainOfflineModel.fromJson(Map<dynamic, dynamic> json) {
    attributeValue = json['attributeValue'] as String;
    categoryCode = json['categoryCode'] as String;
    categoryName = json['categoryName'] as String;
    productName = json['productName'] as String;
    casetypeName = json['casetypeName'] as String;
    attributeCode = json['attributeCode'] as String;
    subcategoryName = json['subcategoryName'] as String;
    productCode = json['productCode'] as String;
    productValue = json['productValue'] as String;
    subcategoryValue = json['subcategoryValue'] as String;
    casetypeCode = json['casetypeCode'] as String;
    categoryValue = json['categoryValue'] as String;
    casetypeValue = json['casetypeValue'] as String;
    attributeName = json['attributeName'] as String;
    subcategoryCode = json['subcategoryCode'] as String;
    // id = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attributeValue'] = this.attributeValue;
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['productName'] = this.productName;
    data['casetypeName'] = this.casetypeName;
    data['attributeCode'] = this.attributeCode;
    data['subcategoryName'] = this.subcategoryName;
    data['productCode'] = this.productCode;
    data['productValue'] = this.productValue;
    data['subcategoryValue'] = this.subcategoryValue;
    data['casetypeCode'] = this.casetypeCode;
    data['categoryValue'] = this.categoryValue;
    data['casetypeValue'] = this.casetypeValue;
    data['attributeName'] = this.attributeName;
    data['subcategoryCode'] = this.subcategoryCode;
    return data;
  }
}
