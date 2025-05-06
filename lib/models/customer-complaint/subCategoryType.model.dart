// class SubCategoryTypeModel extends Equatable {
class SubCategoryTypeModel {
  final String? attributeValue;
  final String? attributeCode;
  // final int id;
  
  SubCategoryTypeModel({
    this.attributeValue, 
    this.attributeCode,
  });

  Map<String, dynamic> toJson() => {
        'attributeValue': attributeValue,
        'attributeCode': attributeCode,
        // 'id': id
      };
      
  factory SubCategoryTypeModel.fromJson(Map<String, dynamic> categoryType) {
    return SubCategoryTypeModel(
      attributeValue: categoryType['attributeValue'] as String?,
      attributeCode: categoryType['attributeCode'] as String?,
      // id: DateTime.now().microsecondsSinceEpoch
    );
  }

  // @override
  // List<Object?> get props => [attributeCode, attributeValue];
}