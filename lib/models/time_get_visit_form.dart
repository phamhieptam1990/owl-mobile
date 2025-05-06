class TimeGetVisitForm {
  TimeGetVisitForm({
    this.visitForm,
  });

  final List<int>? visitForm;

  factory TimeGetVisitForm.fromJson(Map<String, dynamic> json) =>
      TimeGetVisitForm(
        visitForm: json["visitForm"] == null
            ? null
            : List<int>.from(json["visitForm"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "visitForm": visitForm == null
            ? null
            : List<dynamic>.from((visitForm??[]).map((x) => x)),
      };
}
