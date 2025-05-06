class FieldActions {
  String? category;
  String? subcategory;
  String? name;
  String? note;
  FieldActions({this.category, this.subcategory, this.name, this.note});

  FieldActions.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subcategory = json['subcategory'];
    name = json['name'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['name'] = this.name;
    data['note'] = this.note;
    return data;
  }
}
