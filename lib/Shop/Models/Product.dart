class Product {
  String partitionKey;
  String rowKey;
  String groupRowKey;
  String storeRowKey;
  int seq;
  String name; // Added property for product name
  String description; // Added property for product description
  String languageID; // Added property for language ID
  String imageURL;
  int price;
  int productQuantity;
  int cartQuantity;
  bool productAvailability;
  double productRating;
  String productReviews;
  String productSpecifications;
  String productBrand;
  double productWeight;
  String productDimensions;
  bool active;


  Product({
    required this.partitionKey,
    required this.rowKey,
    required this.groupRowKey,
    required this.storeRowKey,
    required this.seq,
    required this.imageURL,
    required this.price,
    required this.productQuantity,
    required this.cartQuantity,
    required this.productAvailability,
    required this.productRating,
    required this.productReviews,
    required this.productSpecifications,
    required this.productBrand,
    required this.productWeight,
    required this.productDimensions,
    required this.active,
    required this.name,
    required this.description,
    required this.languageID,
  });

  // Factory method to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      partitionKey: json['partitionKey'],
      rowKey: json['rowKey'],
      groupRowKey: json['groupRowKey'],
      storeRowKey: json['storeRowKey'],
      seq: json['seq'],
      imageURL: json['imageURL'],
      price: json['price'],
      productQuantity: json['productQuantity'],
      cartQuantity: 1,
      productAvailability: json['productAvailability'],
      productRating: json['productRating'],
      productReviews: json['productReviews'],
      productSpecifications: json['productSpecifications'],
      productBrand: json['productBrand'],
      productWeight: json['productWeight'],
      productDimensions: json['productDimensions'],
      active: json['active'],
      name: json['name'],
      description: json['description'],
      languageID: json['languageID'],
    );
  }

  // Method to convert a Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'PartitionKey': partitionKey,
      'RowKey': rowKey,
      'GroupRowKey': groupRowKey,
      'StoreRowKey': storeRowKey,
      'Seq': seq,
      'ImageURL': imageURL,
      'Price': price,
      'ProductQuantity': productQuantity,
      'cartQuantity': cartQuantity,
      'ProductAvailability': productAvailability,
      'ProductRating': productRating,
      'ProductReviews': productReviews,
      'ProductSpecifications': productSpecifications,
      'ProductBrand': productBrand,
      'ProductWeight': productWeight,
      'ProductDimensions': productDimensions,
      'Active': active,
      'Name': name,
      'Description': description,
      'LanguageID': languageID,
    };
  }
}
