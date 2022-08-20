import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rentkars/main_screens/cart_screen.dart';
import 'package:rentkars/main_screens/custormer_home_screen.dart';

import 'package:rentkars/provider/cart_provider.dart';
import 'package:rentkars/provider/stripe_id.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('customers');

  late String orderId;

  showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
      max: 100,
      msg: 'please wait ...',
      progressBgColor: Colors.cyan,
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  title: Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(
                    14,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${totalPaid.toStringAsFixed(2)} USD',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Order',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    '${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipping Cost',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '10 USD',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: Text(
                                  'Cash on Delivery',
                                ),
                                subtitle: Text(
                                  'Pay From Home',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              RadioListTile(
                                  value: 2,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: Text(
                                    'Pay Via Visa or Master Card',
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.payment,
                                          color: Colors.cyan,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: Colors.cyan,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Colors.cyan,
                                        ),
                                      )
                                    ],
                                  )),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: Text(
                                  'Stripe',
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.ccStripe,
                                      color: Colors.cyan,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CyanButton(
                          onPressed: () async {
                            if (selectedValue == 1) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Pay at Home ${totalPaid.toStringAsFixed(2)} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CyanButton(
                                                    buttonTitle:
                                                        "Confirm ${totalPaid.toStringAsFixed(2)} ",
                                                    onPressed: () async {
                                                      showProgress();
                                                      for (var item in context
                                                          .read<Cart>()
                                                          .getItems) {
                                                        CollectionReference
                                                            orderRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders');
                                                        orderId = Uuid().v4();

                                                        await orderRef
                                                            .doc(orderId)
                                                            .set(
                                                          {
                                                            'cid': data['cid'],
                                                            'customerName':
                                                                data['name'],
                                                            'email':
                                                                data['email'],
                                                            'address':
                                                                data['address'],
                                                            'phone':
                                                                data['phone'],
                                                            'profilePic': data[
                                                                'profilePic'],
                                                            'sellerUid':
                                                                item.sellerUid,
                                                            'productId':
                                                                item.documentId,
                                                            'orderId': orderId,
                                                            'orderName':
                                                                item.name,
                                                            'orderImage': item
                                                                .imagesUrl
                                                                .first,
                                                            'orderQuantity':
                                                                item.quantity,
                                                            'orderPrice':
                                                                item.quantity *
                                                                    item.price,
                                                            'deliverStatus':
                                                                'preparing',
                                                            'deliveryDate': '',
                                                            'orderDate':
                                                                DateTime.now(),
                                                            'paymentStatus':
                                                                'Cash on Delivery',
                                                            'orderReview':
                                                                false,
                                                          },
                                                        ).whenComplete(() {
                                                          context
                                                              .read<Cart>()
                                                              .clearCart();
                                                          Navigator.pushNamed(
                                                              context,
                                                              CustomHomeScreen
                                                                  .routeName);
                                                          print('Cleared');
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            } else if (selectedValue == 2) {
                            } else if (selectedValue == 3) {}
                          },
                          buttonTitle:
                              'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            ),
          );
        });
  }
}
