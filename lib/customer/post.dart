

import 'dart:convert';

Custpost postFromJson(String str) => Custpost.fromJson(json.decode(str));

String postToJson(Custpost data) => json.encode(data.toJson());

class Custpost {
   int?custId;
  String custName;
  String city;
    String phoneNumber;

    Custpost({
     this.custId,
        required this.custName,
        required this.city,
        required this.phoneNumber,
    });

    factory Custpost.fromJson(Map<String, dynamic> json) => Custpost(
        custId: json["cust_Id"],
        custName: json["cust_Name"],
        city: json["city"],
        phoneNumber: json["phone_Number"],
    );

    Map<String, dynamic> toJson() => {
        "cust_Id": custId,
        "cust_Name": custName,
        "city": city,
        "phone_Number": phoneNumber,
    };
}