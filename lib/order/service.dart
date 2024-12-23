import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/order/post.dart';


class OrderService {
  Future<bool> submitOrder(Postord order, String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5251/api/OrderthController1/addOrderTH"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting order: $e');
      return false;
    }
  }
    Future<List<Postord>> fetchOrdersByCustomerId(int custId) async{
     try{
      final response = await http.get(Uri.parse("http://localhost:5251/api/OrderthController1/GetAllOrderth"),
         headers: {'Content-Type': 'application/json'},);
         if (response.statusCode == 200) {
        List<dynamic> orderJson = json.decode(response.body);
        return orderJson.map((json) => Postord.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
     print('Error fetching orders: $e');
      return [];
     }
    }
    Future<Map<int, List<Postord>>> fetchAllOrdersGroupedByCustomer() async {
  try {
    final response = await http.get(
      Uri.parse("http://localhost:5251/api/OrderthController1/GetOrderHistory"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
   
      List<dynamic> orderJson = json.decode(response.body);
      Map<int, List<Postord>> ordersGroupedByCustomer = {};
      for (var jsonOrder in orderJson) {
        Postord order = Postord.fromJson(jsonOrder);

     
        if (!ordersGroupedByCustomer.containsKey(order.custId)) {
          ordersGroupedByCustomer[order.custId] = [];
        }
        ordersGroupedByCustomer[order.custId]!.add(order);
      }

      return ordersGroupedByCustomer; 
    } else {
      return {};
    }
  } catch (e) {
    print('Error fetching orders: $e');
    return {}; 
  }
}
}
