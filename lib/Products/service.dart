import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shop/Products/model.dart'; // Import the Post model

class ProductServices {
  // API endpoint where the product will be added
  final String apiUrl = "http://localhost:5251/AddAllProduct";  // Replace with your actual API URL

  // Function to add product
  Future<bool> addProducts(Post product) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5251/AddAllProduct"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prod_Name': product.prodName,
          'prod_Price': product.prodPrice,
          'stock': product.stock,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Product added successfully
      } else {
        return false; // Failed to add product
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  // Optional: Fetch products (if needed)
  Future<List<Post>> fetchProducts(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        return responseBody.map((product) => Post.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
