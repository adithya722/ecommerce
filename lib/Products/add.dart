import 'package:flutter/material.dart';
import 'package:shop/Products/model.dart';
import 'package:shop/Products/service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool isLoading = false;
  String message = '';

  // Function to add product
  void addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      double price = double.tryParse(_priceController.text) ?? 0.0;
      int stock = int.tryParse(_stockController.text) ?? 0;

      // Create a new Post object
      Post product = Post(
        prodName: _nameController.text,
        prodPrice: price,
        stock: stock,
      );

      // Call the service to add the product
      bool success = await ProductServices().addProducts(product);

      setState(() {
        isLoading = false;
        message = success ? 'Product added successfully!' : 'Failed to add product.';
      });

      // Show snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // Clear the form after successful submission
        _nameController.clear();
        _priceController.clear();
        _stockController.clear();
      }
    } else {
      setState(() {
        message = 'Please fill in all fields.';
      });

      // Show snackbar for missing fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to make layout responsive
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.04), // Responsive spacing

              // Product Price Input
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.04), // Responsive spacing

              // Product Stock Input
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Product Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid stock quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.08), // Responsive spacing

              // Submit Button
              ElevatedButton(
                onPressed: isLoading ? null : addProduct, // Disable button when loading
                child: isLoading
                    ? CircularProgressIndicator() // Show loading indicator when isLoading is true
                    : Text('Add Product'),
              ),
              SizedBox(height: 16),

              // Display message if any
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    color: message == 'Product added successfully!'
                        ? Colors.green
                        : message == 'Please fill in all fields.'
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
