import 'dart:convert';

class Store {
  String partitionKey;
  String rowKey;
  int seq;
  String groupRowKey;
  String name;
  String description;
  String location;
  bool active;
  int openingHours;
  int closingHours;
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
    required this.groupRowKey,
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
      partitionKey: json['partitionKey'] ?? '',
      rowKey: json['rowKey'] ?? '',
      groupRowKey: json['groupRowKey'] ?? '',
      seq: json['seq'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      active: json['active'] ?? false,
      openingHours: json['openingHours'] ?? 0,
      closingHours: json['closingHours'] ?? 0,
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      imageURL: json['imageURL'] ?? '',
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      numberOfRatings: json['numberOfRatings'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      longitude: json['longitude'] ?? 0,
      latitude: json['latitude'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'seq': seq,
      'groupRowKey': groupRowKey,
      'name': name,
      'description': description,
      'location': location,
      'active': active,
      'openingHours': openingHours,
      'closingHours': closingHours,
      'contactNumber': contactNumber,
      'email': email,
      'website': website,
      'imageURL': imageURL,
      'rating': rating,
      'numberOfRatings': numberOfRatings,
      'tags': tags,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
