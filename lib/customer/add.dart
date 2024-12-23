import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop/Products/add.dart';
import 'package:shop/Products/view.dart';
import 'package:shop/customer/view.dart';
import 'package:shop/home.dart';
import 'package:shop/order/cart.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _custNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isLoading = false;
  String message = '';

  int _selectedIndex = 1; // Default to AddCustomerPage tab

  // Handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProducts()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart:[])));
        break;
    }
  }

  void _submitCustomer() {
    if (_custNameController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        message = '';
      });

      // Fake success for now
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
          message = 'Customer added successfully!';
          _custNameController.clear();
          _cityController.clear();
          _phoneController.clear();
        });
      });
    } else {
      setState(() {
        message = 'Please fill in all fields.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
        backgroundColor: const Color.fromARGB(255, 60, 101, 135),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 69, 93, 110),
              ),
              child: Center(
                child: Text(
                  'Navigation Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Customer List'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CustomerListPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add Products'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AddProductPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Name
            TextField(
              controller: _custNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // City
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Phone Number
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Submit Button with animation
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitCustomer,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 80, 79, 133),
                    ),
                    child: Text(
                      'Add Customer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
            SizedBox(height: screenHeight * 0.02),

            // Message with fade animation
            AnimatedOpacity(
              opacity: message.isEmpty ? 0.0 : 1.0,
              duration: Duration(seconds: 1),
              child: Text(
                message,
                style: TextStyle(
                  color: message == 'Customer added successfully!'
                      ? Colors.green
                      : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.white,
        color: const Color(0xFF466C9A),
        buttonBackgroundColor: const Color(0xFF778DA7),
        animationDuration: const Duration(milliseconds: 300),
        items:  [
          Icon(Icons.home, size: 27, color: Colors.white),
          Icon(Icons.person, size: 27, color: Colors.white),
          Icon(Icons.shopping_cart, size: 27, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart: [])));
        },
        backgroundColor: const Color(0xFF466C9A),
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
