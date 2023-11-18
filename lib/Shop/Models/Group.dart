class Group {
  String partitionKey;
  String rowKey;
  int seq;
  String name;
  String description;
  String languageID;
  String imageURL;
  bool active;

  Group({
    required this.partitionKey,
    required this.rowKey,
    required this.seq,
    required this.name,
    required this.description,
    required this.languageID,
    required this.imageURL,
    required this.active,
  });

  // Convert Group object to JSON
  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'seq': seq,
      'name': name,
      'description': description,
      'languageID': languageID,
      'imageURL': imageURL,
      'active': active,
    };
  }

  // Create Group object from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      partitionKey: json['partitionKey'] ?? '',
      rowKey: json['rowKey']?? '',
      seq: json['seq']??0,
      name: json['name']?? '',
      description: json['description']?? '',
      languageID: json['languageID']?? '',
      imageURL: json['imageURL']?? '',
      active: json['active']?? false,
    );
  }


}
