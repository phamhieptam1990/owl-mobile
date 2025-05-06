
class MapModel {
  final input;

  MapModel(this.input);

  MapModel.fromJson(Map<String, dynamic> json)
      : input = json['input'];

  Map<String, dynamic> toJson() => {
        'input': input,
      };
}
