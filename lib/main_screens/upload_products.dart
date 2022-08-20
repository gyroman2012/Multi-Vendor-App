import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentkars/utilities/categ_list.dart';
import 'package:rentkars/utils/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final FirebaseStorage firestore = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mainCategoryValue = 'select category';
  String subCategoryValue = 'sub category';

  List<String> subCategoryList = [];

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  late String productId;
  bool isLoading = false;

  List<XFile> imageFileList = [];
  List<String> imageFileUrl = [];
  dynamic _pickedImageError;
  void _pickProductsImages() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 70,
        maxWidth: 1440,
      );

      setState(() {
        imageFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e.toString();
      });
    }
  }

  Widget previewImages() {
    if (imageFileList.isNotEmpty) {
      return InkWell(
        onTap: () {
          setState(() {
            imageFileList = [];
          });
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageFileList.length,
            itemBuilder: (BuildContext context, index) {
              return Image.file(File(imageFileList[index].path));
            }),
      );
    } else {
      return Center(
        child: Text(
          'you have not \n \n picked images yet !',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }
  }

  Future<void> uploadImages() async {
    if (_formkey.currentState!.validate()) {
      if (imageFileList.isNotEmpty) {
        _formkey.currentState!.save();

        for (var image in imageFileList) {
          Reference ref = firestore
              .ref()
              .child(
                'products',
              )
              .child('${path.basename(image.path)}');

          await ref.putFile(File(image.path)).whenComplete(() async {
            await ref.getDownloadURL().then((value) async {
              imageFileUrl.add(value);
            });
          });
        }

        _formkey.currentState!.reset();
      } else {
        return ShowSnackBar(context, 'you need to pick images');
      }
    } else {
      ShowSnackBar(
        context,
        'please enter all fields',
      );
    }
  }

  uploadData() async {
    if (imageFileList.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      productId = Uuid().v4();
      await _firebaseFirestore.collection('products').doc().set({
        'productid': productId,
        'maincategory': mainCategoryValue,
        'subcategory': subCategoryValue,
        'price': price,
        'instock': quantity,
        'productname': productName,
        'productdescription': productDescription,
        'sellerUid': _auth.currentUser!.uid,
        'productimage': imageFileUrl,
        'discount': 0,
      }).whenComplete(() {
        setState(() {
          setState(() {
            isLoading = false;
          });
          imageFileList = [];
          subCategoryList = [];
          imageFileUrl = [];
        });
        _formkey.currentState!.reset();
      });
    } else {
      print('No Images uploaded');
    }
  }

  void uploadProducts() async {
    await uploadImages().whenComplete(() {
      return uploadData();
    });
  }

  selectCategory(String? value) {
    if (value == 'men') {
      subCategoryList = men;
    } else if (value == 'women') {
      subCategoryList = women;
    } else if (value == 'electronics') {
      subCategoryList = electronics;
    } else if (value == 'accessories') {
      subCategoryList = accessories;
    } else if (value == 'shoes') {
      subCategoryList = shoes;
    } else if (value == 'homeandgarden') {
      subCategoryList = homeandgarden;
    } else if (value == 'beauty') {
      subCategoryList = beauty;
    } else if (value == 'kids') {
      subCategoryList = kids;
    } else if (value == 'bags') {
      subCategoryList = bags;
    }
    setState(() {
      mainCategoryValue = value!;
      subCategoryValue = 'sub category';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      color: Colors.blueGrey.shade100,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: imageFileList != null
                          ? previewImages()
                          : Center(
                              child: Text(
                                'you have not \n \n picked images yet !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            'Select main Category',
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          ),
                          DropdownButton(
                            value: mainCategoryValue,
                            items: maincateg
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              selectCategory(value);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Select sub Category',
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          ),
                          DropdownButton(
                            value: subCategoryValue,
                            items: subCategoryList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(
                                () {
                                  subCategoryValue = value!;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                  child: Divider(
                    color: Colors.cyan,
                    thickness: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Price";
                        } else if (value.isPrice() != true) {
                          return 'not a valid input';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                        hintText: 'Enter  Price',
                        labelStyle: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onSaved: (value) {
                        price = double.parse(value!);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Quantity";
                        } else if (value.isValidQuantity() != true) {
                          return 'not a valid quantity';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Add Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSaved: (value) {
                        quantity = int.parse(value!);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Product name";
                        } else {
                          return null;
                        }
                      },
                      maxLength: 100,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Product name',
                        labelStyle: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Enter Product name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onSaved: (value) {
                        productName = value!;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Product description";
                        } else {
                          return null;
                        }
                      },
                      maxLength: 1000,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        hintText: 'Enter Product Description',
                        labelStyle: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onSaved: (value) {
                        productDescription = value!;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: () {
                _pickProductsImages();
              },
              backgroundColor: Colors.cyan,
              child: Icon(
                Icons.photo_library,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              uploadProducts();
            },
            backgroundColor: Colors.cyan,
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Icon(
                    Icons.upload,
                  ),
          )
        ],
      ),
    );
  }
}

extension QunatityValidator on String {
  bool isValidQuantity() {
    return RegExp(r"^[1-9][0-9]*$").hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isPrice() {
    return RegExp(r"^[1-9][0-9]*$").hasMatch(this);
  }
}
