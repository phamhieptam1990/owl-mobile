class TrackingModel {
  int? id;
  String? code;
  String? name;
  int? localityTypeId;

  TrackingModel({
    this.id,
    this.code,
    this.name,
    this.localityTypeId,
  });

  TrackingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    localityTypeId = json['localityTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['localityTypeId'] = this.localityTypeId;

    return data;
  }
}
