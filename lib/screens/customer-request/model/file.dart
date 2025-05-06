class ImageModel {
  String? fileName;
  String? filePath;
  String? mimeType;
  double? size;
  int? id;
  String? refCode;
  String? storeCode;
  int? makerDate;
  String? makerId;
  // Constructor
  ImageModel(this.id, this.fileName, this.filePath, this.mimeType, this.size,
      this.refCode, this.storeCode, this.makerDate, this.makerId);

  // Named Constructor
  //* Using a named constructor allowing you to initialize an ImageModel with the entire JSON map(object), or your own custom parameters by using the default constructor
  ImageModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    fileName = parsedJson['fileName'];
    filePath = parsedJson['filePath'];
    mimeType = parsedJson['mimeType'];
    size = parsedJson['size'];
    refCode = parsedJson['refCode'];
    storeCode = parsedJson['storeCode'];
    makerDate = parsedJson['makerDate'];
    makerId = parsedJson['makerId'];
  }

  //* Below is the same as above
  // ImageModel.fromJson(Map<String, dynamic> parsedJson)
  //     : id = parsedJson['id'],
  //       url = parsedJson['url'],
  //       title = parsedJson['title'];
}
