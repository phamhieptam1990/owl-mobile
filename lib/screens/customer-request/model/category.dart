class FieldActions {
  String? category;
  String? subCategory;
  String? name;
  String? note;
  FieldActions({this.category, this.subCategory, this.name, this.note});

  FieldActions.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subCategory = json['subCategory'];
    name = json['name'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['subCategory'] = this.subCategory;
    data['name'] = this.name;
    data['note'] = this.note;
    return data;
  }
}
