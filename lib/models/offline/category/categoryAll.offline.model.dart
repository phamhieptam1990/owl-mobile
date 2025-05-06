import 'package:hive/hive.dart';
part 'categoryAll.offline.model.g.dart';

@HiveType(typeId: 1)
class CategoryAllOfflineModel extends HiveObject {
  @HiveField(0)
  dynamic fetmContactPeoples;

  @HiveField(1)
  dynamic fetmContactPlaces;

  @HiveField(2)
  dynamic fetmContactMode;

  @HiveField(3)
  dynamic fetbFieldActions;

  @HiveField(4)
  dynamic fetmActionGroups;

  @HiveField(5)
  dynamic fetmFieldTypes;

  @HiveField(6)
  dynamic fetmFieldReason;

  @HiveField(7)
  dynamic fetmActionAttribute;

  @HiveField(8)
  dynamic locality;

  @HiveField(9)
  dynamic fetmActionSubAttribute;

  CategoryAllOfflineModel(
      {this.fetmContactPeoples,
      this.fetmContactPlaces,
      this.fetmContactMode,
      this.fetbFieldActions,
      this.fetmActionGroups,
      this.fetmFieldTypes,
      this.fetmActionAttribute,
      this.fetmFieldReason,
      this.fetmActionSubAttribute,
      this.locality});

  Map toJson() => {
        'fetmContactPeoples': fetmContactPeoples,
        'fetmContactPlaces': fetmContactPlaces,
        'fetmContactMode': fetmContactMode,
        'fetbFieldActions': fetbFieldActions,
        'fetmActionGroups': fetmActionGroups,
        'fetmFieldTypes': fetmFieldTypes,
        'fetmFieldReason': fetmFieldReason,
        'fetmActionAttribute': fetmActionAttribute,
        'fetmActionSubAttribute': fetmActionSubAttribute,
        'locality': locality
      };
  factory CategoryAllOfflineModel.fromJson(
      Map<dynamic, dynamic> _categoryAllOfflineModel) {
    return CategoryAllOfflineModel(
        fetmContactPeoples: _categoryAllOfflineModel['fetmContactPeoples'],
        fetmContactPlaces: _categoryAllOfflineModel['fetmContactPlaces'],
        fetmContactMode: _categoryAllOfflineModel['fetmContactMode'],
        fetbFieldActions: _categoryAllOfflineModel['fetbFieldActions'],
        fetmActionGroups: _categoryAllOfflineModel['fetmActionGroups'],
        fetmFieldTypes: _categoryAllOfflineModel['fetmFieldTypes'],
        fetmActionAttribute: _categoryAllOfflineModel['fetmActionAttribute'],
        fetmActionSubAttribute:
            _categoryAllOfflineModel['fetmActionSubAttribute'],
        fetmFieldReason: _categoryAllOfflineModel['fetmFieldReason'],
        locality: _categoryAllOfflineModel['locality']);
  }
}
