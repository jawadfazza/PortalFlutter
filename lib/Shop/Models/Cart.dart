class Cart {
  String partitionKey;
  String rowKey;
  String userRowKey;
  String storeRowKey;
  int seq;
  String discountCode;
  double netPrice;
  double discount;
  double totalPrice;
  String paymentMethod;

  DateTime requestDate;
  String status;

  // User-related properties
  String userId;
  String userName;
  String userReview;
  DateTime updateDate;
  int rate;

  // Delivery properties
  String deliveryId;
  String deliveryName;
  double deliveryCost;
  String handOverDatetime;
  String deliveredDatetime;
  double longitude;
  double latitude;

  Cart({
    required this.partitionKey,
    required this.rowKey,
    required this.userRowKey,
    required this.storeRowKey,
    required this.seq,
    required this.discountCode,
    required this.netPrice,
    required this.discount,
    required this.totalPrice,
    required this.paymentMethod,
    required this.requestDate,
    required this.status,
    required this.userId,
    required this.userName,
    required this.userReview,
    required this.updateDate,
    required this.rate,
    required this.deliveryId,
    required this.deliveryName,
    required this.deliveryCost,
    required this.handOverDatetime,
    required this.deliveredDatetime,
    required this.longitude,
    required this.latitude,
  });

  // Convert Cart object to Map (JSON representation)
  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'userRowKey': userRowKey,
      'storeRowKey': storeRowKey,
      'seq': seq,
      'discountCode': discountCode,
      'netPrice': netPrice,
      'discount': discount,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
      'userId': userId,
      'userName': userName,
      'userReview': userReview,
      'updateDate': updateDate.toIso8601String(),
      'rate': rate,
      'deliveryId': deliveryId,
      'deliveryName': deliveryName,
      'deliveryCost': deliveryCost,
      'handOverDatetime': handOverDatetime,
      'deliveredDatetime': deliveredDatetime,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  // Create Cart object from Map (JSON representation)
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      partitionKey: json['partitionKey'] ?? '',
      rowKey: json['rowKey'] ?? '',
      userRowKey: json['userRowKey'] ?? '',
      storeRowKey: json['storeRowKey'] ?? '',
      seq: json['seq'] ?? 0,
      discountCode: json['discountCode'] ?? '',
      netPrice: json['netPrice'] ?? 0.0,
      discount: json['discount'] ?? 0.0,
      totalPrice: json['totalPrice'] ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      requestDate: DateTime.parse(json['requestDate'] ?? ''),
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userReview: json['userReview'] ?? '',
      updateDate: DateTime.parse(json['updateDate'] ?? ''),
      rate: json['rate'] ?? 0,
      deliveryId: json['deliveryId'] ?? '',
      deliveryName: json['deliveryName'] ?? '',
      deliveryCost: json['deliveryCost'] ?? 0.0,
      handOverDatetime: json['handOverDatetime'] ?? '',
      deliveredDatetime: json['deliveredDatetime'] ?? '',
      longitude: json['longitude'] ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
    );
  }
}
