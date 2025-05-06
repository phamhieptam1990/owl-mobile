// import 'package:equatable/equatable.dart';

// class CategoryTypeModel extends Equatable {
class CategoryTypeModel {
  final String? casetypeName;
  final String? productCode;
  final String? casetypeCode;
  final String? casetypeValue;
  final String? description;
  final String? categoryCode;
  final String? subcategoryCode;
  final String? subcategoryName;
  // final int id;
  
  CategoryTypeModel({
    this.casetypeName,
    this.categoryCode,
    this.productCode,
    this.casetypeCode,
    this.casetypeValue,
    this.subcategoryCode,
    this.subcategoryName,
    // this.id,
    this.description,
  });

  factory CategoryTypeModel.fromJson(Map<String, dynamic> employeeModel) {
    return CategoryTypeModel(
      categoryCode: employeeModel['categoryCode'] as String?,
      casetypeName: employeeModel['casetypeName'] as String?,
      productCode: employeeModel['productCode'] as String?,
      casetypeCode: employeeModel['casetypeCode'] as String?,
      casetypeValue: employeeModel['casetypeValue'] as String?,
      subcategoryCode: employeeModel['subcategoryCode'] as String?,
      subcategoryName: employeeModel['subcategoryName'] as String?,
      description: employeeModel['description'] as String?,
      // id: DateTime.now().microsecondsSinceEpoch
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['casetypeName'] = casetypeName;
    data['categoryCode'] = categoryCode;
    data['productCode'] = productCode;
    data['casetypeCode'] = casetypeCode;
    data['casetypeValue'] = casetypeValue;
    data['subcategoryCode'] = subcategoryCode;
    data['subcategoryName'] = subcategoryName;
    data['description'] = description;
    // data['id'] = id;
    return data;
  }

  // @override
  // List<Object?> get props => [
  //       casetypeName,
  //       categoryCode,
  //       productCode,
  //       casetypeCode,
  //       casetypeValue,
  //       subcategoryCode,
  //       subcategoryName,
  //       description
  //     ];
}