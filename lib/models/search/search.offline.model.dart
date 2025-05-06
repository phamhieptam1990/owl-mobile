import 'package:hive/hive.dart';

part 'search.offline.model.g.dart';

@HiveType(typeId: 11)
class SearchOfflineModel extends HiveObject {
  @HiveField(0)
  String? keyword;

  @HiveField(1)
  String? description;

  @HiveField(2)
  int? makerDate;

  SearchOfflineModel({
    this.keyword,
    this.description,
    this.makerDate,
  });

  Map<String, dynamic> toJson() => {
        'keyword': keyword,
        'description': description,
        'makerDate': makerDate,
      };
      
  factory SearchOfflineModel.fromJson(Map<dynamic, dynamic> searchModel) {
    return SearchOfflineModel(
      keyword: searchModel['keyword'],
      description: searchModel['description'],
      makerDate: searchModel['makerDate'],
    );
  }
}