
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop/Products/model.dart';
import 'package:shop/Products/service.dart';
import 'package:shop/customer/add.dart';
import 'package:shop/customer/post.dart';
import 'package:shop/customer/service.dart';
import 'package:shop/order/post.dart';
import 'package:shop/order/service.dart';
import 'package:shop/Products/view.dart';
class CartPage extends StatefulWidget {
  final List<Post> cart;

  const CartPage({super.key, required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Custpost> customers = [];
  Custpost? selectedCustomer;
  final TextEditingController _dateController = TextEditingController();
  bool isLoading = true;
  String message = '';
  int _currentIndex = 2; // Set CartPage as the default index

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCustomers();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await ProductServices().fetchProducts("http://localhost:5251/GetAllProduct");
      if (response.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          message = "No products available.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Error fetching products.";
      });
    }
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await RemoteServices().fetchCustomers();
      if (response.isNotEmpty) {
        setState(() {
          customers = response;
          selectedCustomer = customers[0];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          message = "No customers available.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Error fetching customers.";
      });
    }
  }

  double getTotalAmount() {
    double total = 0.0;
    for (var product in widget.cart) {
      total += product.prodPrice * product.quantity;
    }
    return total;
  }

  void updateQuantity(Post product, int change) {
    setState(() {
      if (product.quantity + change >= 1) {
        product.quantity += change;
      } else if (product.quantity + change == 0) {
        widget.cart.remove(product);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void placeOrder() async {
    if (selectedCustomer == null || _dateController.text.isEmpty || widget.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields!')),
      );
      return;
    }

    List<Map<String, dynamic>> productOrders = widget.cart.map((product) {
      final quantity = product.quantity;
      final totalAmount = product.prodPrice * quantity;

      return {
        'productName': product.prodName,
        'quantity': quantity,
        'price': product.prodPrice,
        'totalAmount': totalAmount,
        'productId': product.prodId,
      };
    }).toList();

    final order = Postord(
      orderId: 0,
      custId: selectedCustomer?.custId ?? 0,
      orderDate: DateTime.parse(_dateController.text),
      netAmount: getTotalAmount().toInt(),
      ordertd: productOrders.map((product) {
        return Ordertd(
          orderId: 0,
          prodId: product['productId'],
          prodName: product['productName'],
          qnty: product['quantity'],
          totalAmount: product['totalAmount'],
        );
      }).toList(),
    );

    bool success = await OrderService().submitOrder(order, "http://localhost:5251/api/OrderthController1/addOrderTH");

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      setState(() {
        widget.cart.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order')),
      );
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) { // Navigate to ViewProducts when "Home" is clicked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewProducts()),
      );
    }
    if (index == 1) { // Navigate to AddCustomerPage when "Profile" is clicked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddCustomerPage()),
      );
    }
    if (index == 2) { // Stay on CartPage when "Cart" is clicked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CartPage(cart: widget.cart)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.teal,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text("No products in cart"))
          : Column(
              children: [
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (message.isNotEmpty)
                  Center(child: Text(message))
                else ...[
                  DropdownButton<Custpost>(
                    value: selectedCustomer,
                    onChanged: (Custpost? newCustomer) {
                      setState(() {
                        selectedCustomer = newCustomer;
                      });
                    },
                    items: customers.map((Custpost customer) {
                      return DropdownMenuItem<Custpost>(value: customer, child: Text(customer.custName));
                    }).toList(),
                    hint: Text('Select a customer'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      hintText: 'Pick a date',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final product = widget.cart[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.network(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSRudQ7nWMn-ZbVoqvij1uzOFhqj-8fuQj-g&s",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.prodName,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "\$${(product.prodPrice * product.quantity).toStringAsFixed(2)}",
                                        style: TextStyle(color: Colors.green, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        updateQuantity(product, -1);
                                      },
                                    ),
                                    Text("${product.quantity}"),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        updateQuantity(product, 1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Total: \$${getTotalAmount().toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: placeOrder,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text("Place Order"),
                    ),
                  ),
                ],
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
          // Icon(Icons.shopify_outlined, size: 30, color: Colors.white),
        ],
        onTap: _onNavTapped, // Handle tap
      ),
    );
  }
}