class CartProductItem {
  String partitionKey;
  String rowKey;
  String cartRowKey;
  String productRowKey;
  int seq;
  int quantity;
  double price;
  double totalPrice;
  DateTime requestDate;
  String status;

  CartProductItem({
    required this.partitionKey,
    required this.rowKey,
    required this.cartRowKey,
    required this.productRowKey,
    required this.seq,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.requestDate,
    required this.status,
  });

  // Convert CartItem object to Map (JSON representation)
  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'cartRowKey': cartRowKey,
      'productRowKey': productRowKey,
      'seq': seq,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
    };
  }

  // Create CartItem object from Map (JSON representation)
  factory CartProductItem.fromJson(Map<String, dynamic> json) {
    return CartProductItem(
      partitionKey: json['partitionKey'] ?? '',
      rowKey: json['rowKey'] ?? '',
      cartRowKey: json['cartRowKey'] ?? '',
      productRowKey: json['productRowKey'] ?? '',
      seq: json['seq'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0.0,
      totalPrice: json['totalPrice'] ?? 0.0,
      requestDate: DateTime.parse(json['requestDate'] ?? ''),
      status: json['status'] ?? '',
    );
  }
}
