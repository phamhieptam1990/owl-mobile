class MockLocationAppModel {
  String? id;

  MockLocationAppModel({this.id});

  MockLocationAppModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
