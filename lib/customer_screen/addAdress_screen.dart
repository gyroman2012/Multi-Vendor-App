import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentkars/main_screens/cart_screen.dart';
import 'package:rentkars/utils/snackbar.dart';
import 'package:uuid/uuid.dart';

class AddAdressScreen extends StatefulWidget {
  @override
  _AddAdressState createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdressScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String countryValue = 'Choose Country';
  late String stateValue = 'Choose State';
  late String cityValue = 'Choose State';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Address',
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your correct first name';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Enter your first name',
                          hintText: 'Enter your first name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your correct last name';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Enter your last name',
                          hintText: 'Enter your last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          lastName = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your correct phone number';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Enter your phone number',
                          hintText: 'Enter your phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          phone = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                Center(
                  child: CyanButton(
                    buttonTitle: 'Add New Address',
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (countryValue != 'choose Country' &&
                            stateValue != 'Choose State' &&
                            cityValue != 'Choose City') {
                          _formkey.currentState!.save();

                          CollectionReference addressRef = FirebaseFirestore
                              .instance
                              .collection('customers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('address');

                          final addressId = Uuid().v4();

                          await addressRef.doc(addressId).set({
                            'addressId': addressId,
                            'firstName': firstName,
                            'lastName': lastName,
                            'phoneNumber': phone,
                            'countryName': countryValue,
                            'StateName': stateValue,
                            'cityName': cityValue,
                            'default': true,
                          }).whenComplete(() {
                            Navigator.pop(context);
                          });
                        } else {
                          ShowSnackBar(
                              context, 'Please Fields must not be empty');
                        }
                      } else {
                        ShowSnackBar(
                            context, 'Please Fields must not be empty');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
