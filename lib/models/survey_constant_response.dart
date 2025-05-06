import 'dart:convert';

SurveyConstantResponse surveyConstantResponseFromJson(String str) =>
    SurveyConstantResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String surveyConstantResponseToJson(SurveyConstantResponse data) =>
    json.encode(data.toJson());

class SurveyConstantResponse {
  SurveyConstantResponse({
    this.surveys = const [],
  });

  final List<Survey> surveys;

  factory SurveyConstantResponse.fromJson(Map<String, dynamic> json) =>
      SurveyConstantResponse(
        surveys: (json["surveys"] as List<dynamic>?)
                ?.map((x) => Survey.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "surveys": surveys.map((x) => x.toJson()).toList(),
      };
}

class Survey {
  Survey({
    this.roles = const [],
    this.contractType = '',
    this.link = '',
    this.name = '',
  });

  final List<String> roles;
  final String contractType;
  final String link;
  final String name;

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        roles: (json["roles"] as List<dynamic>?)?.map((x) => x as String).toList() ?? [],
        contractType: json["contractType"] as String? ?? '',
        link: json["link"] as String? ?? '',
        name: json["name"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "roles": roles,
        "contractType": contractType,
        "link": link,
        "name": name,
      };
}

class SurveyUtils {
  SurveyUtils._();

  static final SurveyUtils instance = SurveyUtils._();
  List<Survey> surveys = [];
}