import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop/Products/model.dart';
import 'package:shop/Products/service.dart';
import 'package:shop/customer/add.dart';
import 'package:shop/order/cart.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({super.key});

  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  List<Post> products = [];
  List<Post> cart = [];
  List<Post> filteredProducts = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({String query = ''}) async {
    try {
      final apiUrl = "http://localhost:5251/GetAllProduct";
      final fetchedProducts = await ProductServices().fetchProducts(apiUrl);

      setState(() {
        products = fetchedProducts;
        filteredProducts = query.isEmpty
            ? products
            : products
                .where((p) => p.prodName.toLowerCase().contains(query.toLowerCase()))
                .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _navigate(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddCustomerPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart: cart)));
        break;
    }
  }

  void _addToCart(Post product) => setState(() => cart.add(product));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView( // Wrap the whole body with SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 10),
            _buildCarousel(), // CarouselSlider is inserted here
            const SizedBox(height: 10),
            _buildProductGrid(width),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.white,
        color: const Color(0xFF466C9A),
        buttonBackgroundColor: const Color(0xFF778DA7),
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 27, color: Colors.white),
          Icon(Icons.person, size: 27, color: Colors.white),
          Icon(Icons.shopping_cart, size: 27, color: Colors.white),
        ],
        onTap: _navigate,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          fetchProducts(query: query);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFECE9E9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    final images = ["asset/web.jpeg", "asset/phone.jpeg", "asset/footwear.jpeg"];
    return CarouselSlider(
      items: images.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(url, fit: BoxFit.cover, width: double.infinity),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget _buildProductGrid(double width) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (filteredProducts.isEmpty) return const Center(child: Text('No products found'));

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 600 ? 3 : 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (_, i) => ProductCard(
        product: filteredProducts[i],
        onAddToCart: () => _addToCart(filteredProducts[i]),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Post product;
  final VoidCallback onAddToCart;

  const ProductCard({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset("asset/style.jpeg", fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.prodName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text("\$${product.prodPrice}",
                    style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
                ElevatedButton(
                  onPressed: product.stock == 0 ? null : onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: product.stock == 0 ? Colors.grey : const Color(0xFF375983),
                  ),
                  child: Text(product.stock == 0 ? "Out of Stock" : "Add to Cart",
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



