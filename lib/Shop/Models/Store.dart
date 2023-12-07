class Store {
  String partitionKey;
  String rowKey;
  int seq;
  String name;
  String description;
  String location;
  bool active;
  DateTime openingHours;
  DateTime closingHours;
  String contactNumber;
  String email;
  String website;
  String imageURL;
  double rating;
  int numberOfRatings;
  List<String> tags;
  int longitude;
  int latitude;

  Store({
    required this.partitionKey,
    required this.rowKey,
    required this.seq,
    required this.name,
    required this.description,
    required this.location,
    required this.active,
    required this.openingHours,
    required this.closingHours,
    required this.contactNumber,
    required this.email,
    required this.website,
    required this.imageURL,
    required this.rating,
    required this.numberOfRatings,
    required this.tags,
    required this.longitude,
    required this.latitude,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      partitionKey: json['PartitionKey'] ?? '',
      rowKey: json['RowKey'] ?? '',
      seq: json['Seq'] ?? 0,
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      location: json['Location'] ?? '',
      active: json['Active'] ?? false,
      openingHours: DateTime.parse(json['OpeningHours'] ?? ''),
      closingHours: DateTime.parse(json['ClosingHours'] ?? ''),
      contactNumber: json['ContactNumber'] ?? '',
      email: json['Email'] ?? '',
      website: json['Website'] ?? '',
      imageURL: json['ImageURL'] ?? '',
      rating: json['Rating'] ?? 0.0,
      numberOfRatings: json['NumberOfRatings'] ?? 0,
      tags: List<String>.from(json['Tags'] ?? []),
      longitude: json['Longitude'] ?? 0,
      latitude: json['Latitude'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PartitionKey': partitionKey,
      'RowKey': rowKey,
      'Seq': seq,
      'Name': name,
      'Description': description,
      'Location': location,
      'Active': active,
      'OpeningHours': openingHours.toIso8601String(),
      'ClosingHours': closingHours.toIso8601String(),
      'ContactNumber': contactNumber,
      'Email': email,
      'Website': website,
      'ImageURL': imageURL,
      'Rating': rating,
      'NumberOfRatings': numberOfRatings,
      'Tags': tags,
      'Longitude': longitude,
      'Latitude': latitude,
    };
  }
}
