class FirebaseStoreModel {
  String? storeversion;
  String? link;
 

  FirebaseStoreModel(
      {this.storeversion,
      this.link,
     });

  FirebaseStoreModel.fromJson(Map<String, dynamic> json) {
    storeversion = json['store_version'];
    link = json['link'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_version'] = storeversion;
    data['link'] = link;
    return data;
  }
}
