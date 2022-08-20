import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:rentkars/dashboard_screens/delived_screen.dart';
import 'package:rentkars/dashboard_screens/preparing_screen.dart';
import 'package:rentkars/dashboard_screens/shipping_screen.dart';

class SupplierOrderScreen extends StatefulWidget {
  @override
  _SupplierOrderScreenState createState() => _SupplierOrderScreenState();
}

class _SupplierOrderScreenState extends State<SupplierOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.cyan,
            indicatorWeight: 2,
            isScrollable: true,
            tabs: [
              Badge(
                badgeColor: Colors.cyan,
                child: RepeatedTab(
                  text: 'Preparing',
                ),
              ),
              RepeatedTab(
                text: 'Shipping',
              ),
              RepeatedTab(
                text: 'Delivered',
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          PreparingScreen(),
          ShippingScreen(),
          DeliveredScreen(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String text;
  const RepeatedTab({Key? key, required this.text})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
