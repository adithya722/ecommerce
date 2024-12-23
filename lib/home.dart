// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop/Products/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
   

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "asset/footwear.jpeg", // Add your footwear image here
            fit: BoxFit.cover,
          ),
          // Text and Buttons Overlay
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Heading
                Text(
                  "Love the Planet \nwe walk on",
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2, // Line height
                  ),
                ),
                SizedBox(height: 15),
                // Subtext
                Text(
                  "Influential, innovative and progressive,Versace is reinventing a wholly modern "
                  "approach to fashion to help you look unique.",
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30),
                // Buttons
                Row(
                  children: [
                    _buildShopButton("SHOP NOW"),
                 
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Button Widget
  Widget _buildShopButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewProducts()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
