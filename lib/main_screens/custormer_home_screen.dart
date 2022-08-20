import 'package:flutter/material.dart';
import 'package:rentkars/main_screens/cart_screen.dart';
import 'package:rentkars/main_screens/category.dart';
import 'package:rentkars/main_screens/home_screen.dart';
import 'package:rentkars/main_screens/profile_screen.dart';
import 'package:rentkars/main_screens/stores.dart';

class CustomHomeScreen extends StatefulWidget {
  static const String routeName = 'customerHomeScreen';
  @override
  _CustomHomeScreenState createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  final List<Widget> _tabs = [
    HomeScreen(),
    Category(),
    StoresScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.cyan,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: _tabs[pageIndex],
    );
  }
}
