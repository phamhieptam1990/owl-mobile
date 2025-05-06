import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class DocumentOmniChannelModel extends Equatable {
  String? objId;
  String? fileName;
  String? refCode;
  String? mimeType;
  String? docTypeName;
  DocumentOmniChannelModel(
      {this.objId,
      this.fileName,
      this.refCode,
      this.docTypeName,
      this.mimeType});

  DocumentOmniChannelModel.fromJson(Map<String, dynamic> json) {
    objId = json['objId'];
    fileName = json['fileName'];
    refCode = json['refCode'];
    mimeType = json['mimeType'];
    docTypeName = json['docTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objId'] = this.objId;
    data['fileName'] = this.fileName;
    data['refCode'] = this.refCode;
    data['mimeType'] = this.mimeType;
    data['docTypeName'] = this.docTypeName;
    return data;
  }

  @override
  List<Object?> get props => [objId, fileName, refCode, mimeType];
}
