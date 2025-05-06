import 'dart:io';

class FileLocal {
  final String key;
  final String name;
  final File file;

  FileLocal(this.key, this.name, this.file);

  FileLocal.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        name = json['name'],
        file = json['file'];

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'file': file,
      };
}
