import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop/customer/post.dart';
class RemoteServices {
  static const String _url =
      'http://localhost:5251/api/Home/GetAllHome';

  // Fetch customers from the API
  Future<List<Custpost>> fetchCustomers() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Custpost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<bool> addCustomer(Custpost customer) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://localhost:5251/api/Home/AddAllCustomer"),

        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cust_Name': customer.custName,
          'city': customer.city,
          'phone_Number': customer.phoneNumber
        }),
        
      );
      // print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
// Update Customer API
  // Update Customer API
  Future<bool> updateCustomer(Custpost customer) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:5251/api/Home/UpdateCustomer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'cust_Id': customer.custId,
          'cust_Name': customer.custName,
          'city': customer.city,
          'phone_Number': customer.phoneNumber,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  // Delete Customer API
  Future<bool> deleteCustomer(int custId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:5251/api/Home/DeleteCustomer/$custId'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
