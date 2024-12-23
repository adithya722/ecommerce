// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop/Products/view.dart';
import 'package:shop/customer/add.dart';
import 'package:shop/customer/post.dart';
import 'package:shop/customer/service.dart';
import 'package:shop/order/cart.dart';
import 'package:shop/order/post.dart';
import 'package:shop/order/service.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Custpost> customers = [];
  List<Custpost> filteredCustomers = [];
  bool isLoading = true;
  String message = '';
  TextEditingController _searchController = TextEditingController();

  int _currentIndex = 1; // Bottom navigation index

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  // Fetch customer data from API
  void fetchCustomers() async {
    try {
      List<Custpost> fetchedCustomers = await RemoteServices().fetchCustomers();

      // Filter customers with orders (if applicable)
      List<Custpost> customersWithOrders = [];
      for (var customer in fetchedCustomers) {
        Map<int, List<Postord>> orders =
            await OrderService().fetchAllOrdersGroupedByCustomer();
        if (orders.isNotEmpty) {
          customersWithOrders.add(customer);
        }
      }

      setState(() {
        customers = customersWithOrders;
        filteredCustomers = customers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        message = 'Failed to load customers.';
      });
    }
  }

  // Search functionality for customers
  void _onSearchChanged(String query) {
    setState(() {
      filteredCustomers = customers
          .where((customer) =>
              customer.custName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Navigation handling for bottom navigation bar
  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewProducts()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddCustomerPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage(cart: [])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(255, 236, 233, 233),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredCustomers.isEmpty
                    ? Center(child: Text('No customers found'))
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width > 600 ? 3 : 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomers[index];
                          return CustomerCard(
                            customer: customer,
                            allCustomers: customers,
                            onRefresh: fetchCustomers,
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: Color.fromARGB(255, 42, 80, 127),
        buttonBackgroundColor: Color.fromARGB(255, 119, 141, 167),
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, size: 27, color: Colors.white),
          Icon(Icons.person_2_outlined, size: 27, color: Colors.white),
          Icon(Icons.shopping_cart, size: 27, color: Colors.white),
        ],
        onTap: _onNavTapped,
      ),
    );
  }
}

class CustomerCard extends StatefulWidget {
  final Custpost customer;
  final List<Custpost> allCustomers; // To check for duplicate phone numbers
  final VoidCallback onRefresh; // Callback to refresh the list after edits/deletes

  const CustomerCard({
    required this.customer,
    required this.allCustomers,
    required this.onRefresh,
  });

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customer.custName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  widget.customer.city,
                  style: TextStyle(
                      color: Color.fromARGB(255, 70, 95, 126), fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  widget.customer.phoneNumber,
                  style: TextStyle(
                      color: Color.fromARGB(255, 70, 95, 126), fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => showOrderHistory(widget.customer.custId!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 55, 89, 131),
                      ),
                      child: Text("View Orders", style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editCustomer(widget.customer),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCustomer(widget.customer),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editCustomer(Custpost customer) {
    // Populate fields with current values
    TextEditingController nameController =
        TextEditingController(text: customer.custName);
    TextEditingController cityController =
        TextEditingController(text: customer.city);
    TextEditingController phoneController =
        TextEditingController(text: customer.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Customer"),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: "City"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Check for duplicate phone number
                String newPhoneNumber = phoneController.text.trim();
                bool isDuplicate = widget.allCustomers.any((c) =>
                    c.phoneNumber == newPhoneNumber && c.custId != customer.custId);

                if (isDuplicate) {
                  // Show alert dialog for duplicate phone number
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Duplicate Phone Number"),
                        content: Text(
                            "The phone number already exists for another customer. Please use a different number."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                  return; // Stop further processing
                }

                final updatedCustomer = Custpost(
                  custId: customer.custId,
                  custName: nameController.text,
                  city: cityController.text,
                  phoneNumber: newPhoneNumber,
                );

                // Proceed with updating the customer
                bool success = await RemoteServices().updateCustomer(updatedCustomer);
                if (success) {
                  Navigator.pop(context); // Close the dialog
                  widget.onRefresh(); // Refresh customer list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update customer")),
                  );
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteCustomer(Custpost customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${customer.custName}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                bool success = await RemoteServices().deleteCustomer(customer.custId!);
                if (success) {
                  Navigator.pop(context);
                  widget.onRefresh(); // Refresh customer list
                } else {
                  // Handle API error
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text("Failed to delete customer. Please try again later."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Show Order History for the selected customer
  void showOrderHistory(int custId) async {
    try {
      Map<int, List<Postord>> groupedOrders =
          await OrderService().fetchAllOrdersGroupedByCustomer();
      List<Postord> customerOrders = groupedOrders[custId] ?? [];

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order History for Customer $custId'),
            content: customerOrders.isEmpty
                ? Text('No orders found for this customer.')
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: customerOrders.map((order) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${order.orderId}'),
                            Text('Order Date: ${order.orderDate}'),
                            Text('Net Amount: ${order.netAmount}'),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing order history: $e');
    }
  }
}

