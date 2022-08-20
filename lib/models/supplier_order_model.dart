import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  const SupplierOrderModel({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> orderData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Name:  ${orderData['customerName']} ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            'Phone:  ${orderData['phone']} ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            'Email:  ${orderData['email']} ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            'Address:  ${orderData['address']} ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            'Payment status:  ${orderData['paymentStatus']} ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            children: [
              Text('Delivery Status'),
              SizedBox(
                width: 20,
              ),
              Text(
                '${orderData['deliverStatus']}',
                style: TextStyle(
                  color: Colors.cyan,
                ),
              )
            ],
          ),
          orderData['deliverStatus'] == 'shipping'
              ? Text(
                  'Estimated Delivery Date:  ${orderData['deliveryDate']} ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              : Text(''),
          Row(
            children: [
              Text(
                ' Order Date ',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(
                  orderData['orderDate'].toDate(),
                ),
              ),
            ],
          ),
          orderData['deliverStatus'] == 'delivered'
              ? Text('This Order has been Delivered')
              : Row(
                  children: [
                    Text(
                      ' Change Delivery Status  ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    orderData['deliverStatus'] == 'preparing'
                        ? TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime.now().add(
                                    Duration(
                                      days: 365,
                                    ),
                                  ), onConfirm: (date) {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderData['orderId'])
                                    .update({
                                  'deliverStatus': 'shipping',
                                  'deliveryDate': date,
                                });
                              });
                            },
                            child: Text('Shipping ?'),
                          )
                        : TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderData['orderId'])
                                  .update({
                                'deliverStatus': 'delivered',
                              });
                            },
                            child: Text('Delivered ?'))
                  ],
                ),
        ],
      ),
    );
  }
}
