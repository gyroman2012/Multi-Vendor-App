import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentkars/auth/seller_login_screen.dart';
import 'package:rentkars/dashboard_screens/edit_profile.dart';
import 'package:rentkars/dashboard_screens/manage_products.dart';
import 'package:rentkars/dashboard_screens/my_store.dart';
import 'package:rentkars/dashboard_screens/statics.dart';
import 'package:rentkars/dashboard_screens/supplier_balance.dart';
import 'package:rentkars/dashboard_screens/supplier_orders.dart';
import 'package:rentkars/minor_screens/visit_store_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> label = [
    'My Store',
    'Orders',
    'Edit Profile',
    'Manage products',
    'Balance ',
    'statics',
  ];

  List<IconData> icons = [
    Icons.store,
    Icons.shop_2_outlined,
    Icons.edit,
    Icons.settings,
    Icons.attach_money,
    Icons.show_chart,
  ];

  List<Widget> pages = [
    VisitStore(sellerUid: FirebaseAuth.instance.currentUser!.uid),
    SupplierOrderScreen(),
    EditProfile(),
    ManageProducts(),
    SupplierBalance(),
    StaticsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacementNamed(
                  context, SellerLoginScreen.routeName);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: GridView.count(
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        crossAxisCount: 2,
        children: List.generate(6, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pages[index]));
            },
            child: Card(
              color: Colors.blueGrey.withOpacity(
                0.7,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    icons[index],
                    color: Colors.cyan,
                    size: 40,
                  ),
                  Text(
                    label[index].toUpperCase(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
