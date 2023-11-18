class SubGroup {
  String partitionKey;
  String rowKey;
  String groupRowKey;
  int seq;
  String name;
  String languageID;
  String imageURL;
  bool active;

  SubGroup({
    required this.partitionKey,
    required this.rowKey,
    required this.groupRowKey,
    required this.seq,
    required this.name,
    required this.languageID,
    required this.imageURL,
    required this.active,
  });

  // Convert Group object to JSON
  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'groupRowKey': groupRowKey,
      'seq': seq,
      'name': name,



      'languageID': languageID,
      'imageURL': imageURL,
      'active': active,
    };
  }

  // Create Group object from JSON
  factory SubGroup.fromJson(Map<String, dynamic> json) {
    return SubGroup(
      partitionKey: json['partitionKey']??'',
      rowKey: json['rowKey']??'',
      groupRowKey: json['groupRowKey']??'',
      seq: json['seq']??0,
      name: json['name']??'',
      languageID: json['languageID']??'',
      imageURL: json['imageURL']??'',
      active: json['active']??false,
    );
  }


}
