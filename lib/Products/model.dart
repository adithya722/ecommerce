class Post {
  int? prodId;
  String prodName;
  double prodPrice;
  int quantity;
  int stock;

  Post({
    this.prodId,
    required this.prodName,
    required this.prodPrice,
    required this.stock,
    this.quantity = 1,
  });

  @override
  String toString() {
    return 'Product Name: $prodName, Price: \$${prodPrice.toStringAsFixed(2)}, Quantity: $quantity';
  }

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        prodId: json["prod_Id"],
        prodName: json["prod_Name"],
        prodPrice: json["prod_Price"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "prod_Id": prodId,
        "prod_Name": prodName,
        "prod_Price": prodPrice,
        "stock": stock,
      };
}