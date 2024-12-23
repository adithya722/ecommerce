import 'dart:convert';

Postord postFromJson(String str) => Postord.fromJson(json.decode(str));
String postToJson(Postord data) => json.encode(data.toJson());

class Postord {
  int orderId;
  int custId;
  DateTime orderDate;
  int netAmount;
  List<Ordertd> ordertd;

  Postord({
    required this.orderId,
    required this.custId,
    required this.orderDate,
    required this.netAmount,
    required this.ordertd,
  });

  factory Postord.fromJson(Map<String, dynamic> json) => Postord(
    orderId: json["orderID"],
    custId: json["cust_Id"],
    orderDate: DateTime.parse(json["orderDate"]),
    netAmount: json["netAmount"],
    ordertd: List<Ordertd>.from(json["ordertd"].map((x) => Ordertd.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderID": orderId,
    "cust_Id": custId,
    "orderDate": orderDate.toIso8601String(),
    "netAmount": netAmount,
    "ordertd": List<dynamic>.from(ordertd.map((x) => x.toJson())),
  };
}

class Ordertd {
  int orderId;
  int prodId;
  String prodName;
  int qnty;
  int totalAmount;

  Ordertd({
    required this.orderId,
    required this.prodId,
    required this.prodName,
    required this.qnty,
    required this.totalAmount,
  });

  factory Ordertd.fromJson(Map<String, dynamic> json) => Ordertd(
    orderId: json["orderID"],
    prodId: json["prod_Id"],
    prodName: json["prod_Name"],  // Product name field added
    qnty: json["qnty"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "orderID": orderId,
    "prod_Id": prodId,
    "prod_Name": prodName,  // Product name field added
    "qnty": qnty,
    "totalAmount": totalAmount,
  };
}
