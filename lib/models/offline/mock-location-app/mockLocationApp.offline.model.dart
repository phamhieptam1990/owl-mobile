import 'package:hive/hive.dart';
part 'mockLocationApp.offline.model.g.dart';

@HiveType(typeId: 9)
class MockLocationAppOfflineModel extends HiveObject {
  @HiveField(0)
  String? id;
  MockLocationAppOfflineModel({this.id});
  Map toJson() => {
        'id': id,
      };
  factory MockLocationAppOfflineModel.fromJson(
      Map<dynamic, dynamic> employeeModel) {
    return MockLocationAppOfflineModel(
      id: employeeModel['id'].toString(),
    );
  }
}
