class SearchModel {
  String? keyword;
  String? description;
  int? makerDate;

  SearchModel({this.keyword, this.description, this.makerDate});

  Map<String, dynamic> toJson() => {
        'keyword': keyword,
        'description': description,
        'makerDate': makerDate,
      };
      
  factory SearchModel.fromJson(Map<dynamic, dynamic> searchModel) {
    return SearchModel(
      keyword: searchModel['keyword'],
      description: searchModel['description'],
      makerDate: searchModel['makerDate'],
    );
  }
}