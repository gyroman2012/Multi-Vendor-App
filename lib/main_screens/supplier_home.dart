import 'package:flutter/material.dart';
import 'package:rentkars/main_screens/cart_screen.dart';
import 'package:rentkars/main_screens/category.dart';
import 'package:rentkars/main_screens/dashboard.dart';
import 'package:rentkars/main_screens/home_screen.dart';

import 'package:rentkars/main_screens/stores.dart';
import 'package:rentkars/main_screens/upload_products.dart';

class SupplierHome extends StatefulWidget {
  static const String routeName = 'supplierHomeScreen';
  @override
  _SupplierHomeState createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  final List<Widget> _tabs = [
    HomeScreen(),
    Category(),
    StoresScreen(),
    DashboardScreen(),
    UploadProductScreen(),
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
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload,
            ),
            label: 'Upload',
          ),
        ],
      ),
      body: _tabs[pageIndex],
    );
  }
}
