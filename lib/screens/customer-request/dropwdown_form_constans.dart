class DropdownFormConstans {
  static final List<DropdownFormItem> list = [
    DropdownFormItem(
        title: 'Athena Owl',
        supportType: 'Athena Owl',
        dropdownFormType: DropdownFormType.icollect),
    DropdownFormItem(
        title: 'Recovery',
        supportType: 'recovery',
        dropdownFormType: DropdownFormType.recovery),
  ];
}

class DropdownFormItem {
  final String? title;
  final String? supportType;
  final DropdownFormType? dropdownFormType;

  DropdownFormItem({this.title, this.supportType, this.dropdownFormType});
}

enum DropdownFormType { icollect, recovery }
