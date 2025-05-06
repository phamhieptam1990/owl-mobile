// class ProductTypeModel extends Equatable {
class ProductTypeModel {
  final String? productName;
  final String? productCode;
  final String? productValue;
  final String? description;
  // final int id;
  
  ProductTypeModel({
    this.productName,
    this.productCode,
    this.productValue,
    this.description,
    // this.id
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productCode': productCode,
        'productValue': productValue,
        'description': description,
        // 'id': id
      };
      
  factory ProductTypeModel.fromJson(Map<String, dynamic> employeeModel) {
    return ProductTypeModel(
      productName: employeeModel['productName'] as String?,
      productCode: employeeModel['productCode'] as String?,
      productValue: employeeModel['productName'] as String?,
      description: employeeModel['productCode'] as String?,
      // id: DateTime.now().microsecondsSinceEpoch
    );
  }

  // @override
  // List<Object?> get props =>
  //     [productName, productCode, productValue, description];
}