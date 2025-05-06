import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'productType.offline.model.g.dart';

@HiveType(typeId: 8)
class ProductTypeOfflineModel extends Equatable {
  @HiveField(0)
  final String? productName;
  @HiveField(1)
  final String? productCode;
  @HiveField(2)
  final String? productValue;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? receiveDate;
  
  ProductTypeOfflineModel({
    this.productName,
    this.productCode,
    this.productValue,
    this.description,
    this.receiveDate,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productCode': productCode,
        'productValue': productValue,
        'description': description,
        'receiveDate': receiveDate,
      };
      
  factory ProductTypeOfflineModel.fromJson(
      Map<dynamic, dynamic> productTypeOfflineModel) {
    return ProductTypeOfflineModel(
      productName: productTypeOfflineModel['productName'] as String?,
      productCode: productTypeOfflineModel['productCode'] as String?,
      productValue: productTypeOfflineModel['productValue'] as String?, // Fixed field name
      description: productTypeOfflineModel['description'] as String?, // Fixed field name
      receiveDate: productTypeOfflineModel['receiveDate'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        productName,
        productCode,
        productValue,
        description,
        receiveDate,
      ];
}