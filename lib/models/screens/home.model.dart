import 'package:hive/hive.dart';
part 'home.model.g.dart';

@HiveType(typeId: 10)
class HomeModel extends HiveObject {
  @HiveField(0)
  int? paid;

  @HiveField(1)
  int? unPaid;

  @HiveField(2)
  int? proposeCalendar;

  @HiveField(3)
  int? doneActionCalendar;

  HomeModel({
    this.paid,
    this.unPaid,
    this.proposeCalendar,
    this.doneActionCalendar,
  });
}