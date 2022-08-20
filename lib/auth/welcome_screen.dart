import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentkars/auth/customer_login_screen.dart';
import 'package:rentkars/auth/seller_register.dart';
import 'package:rentkars/main_screens/custormer_home_screen.dart';
import 'package:rentkars/utils/snackbar.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool isLoading = false;
  bool passwordInvisable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _imageFile;
  dynamic _pickedImageError;
  void _pickImageFromCamera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e.toString();
      });
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  uploadImageToStorage() async {
    Reference ref = _firebaseStorage
        .ref()
        .child('profilePics')
        .child('${_emailController.text}.jpg');

    UploadTask uploadTask = ref.putFile(File(_imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    String profileImage = await snapshot.ref.getDownloadURL();
    return profileImage;
  }

  void signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        if (_imageFile != null) {
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

          String profileImage = await uploadImageToStorage();

          await _firestore
              .collection('customers')
              .doc(_auth.currentUser!.uid)
              .set({
            'name': _fullNameController.text,
            'email': _emailController.text,
            'profilePic': profileImage,
            'phone': '',
            'address': '',
            'cid': _auth.currentUser!.uid,
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushReplacementNamed(
              context, CustomerLoginScreen.routeName);
        } else {
          setState(() {
            isLoading = false;
          });
          return ShowSnackBar(context, 'Please pick an Image');
        }
        print(' valid');
      } else {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, 'Please enter all fields');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "week-password") {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Create customer's Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.person,
                        size: 40,
                        color: Colors.cyan,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.purpleAccent,
                        backgroundImage: _imageFile == null
                            ? null
                            : FileImage(File(_imageFile!.path)),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(
                                    15,
                                  ))),
                          child: IconButton(
                            onPressed: _pickImageFromCamera,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(
                                    15,
                                  ))),
                          child: IconButton(
                            onPressed: _pickImageFromGallery,
                            icon: Icon(
                              Icons.photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full Name';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your correct Email address';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else {
                        return null;
                      }
                    },
                    obscureText: passwordInvisable,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordInvisable = !passwordInvisable;
                          });
                        },
                        icon: Icon(
                          passwordInvisable
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width - 30,
                      40,
                    ),
                  ),
                  onPressed: () {
                    signUp();
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have  an Account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, CustomerLoginScreen.routeName);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
                Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create a Seller's Account ? ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SellerRegisterScreen.routeName);
                      },
                      child: Text(
                        'create Account',
                        style: TextStyle(
                          color: Colors.cyan,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
