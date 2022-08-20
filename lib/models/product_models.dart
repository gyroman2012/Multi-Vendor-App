import 'package:badges/badges.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentkars/detail/products_detail.dart';
import 'package:rentkars/provider/wishlist_provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductsDetails(
                  productList: widget.products,
                );
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxWidth: 250,
                      ),
                      child: Image(
                        image: NetworkImage(
                          widget.products['productimage'][0],
                        ),
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.products['productname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.products['price'].toStringAsFixed(2) +
                                  ' \$ ',
                              style: TextStyle(
                                color: Colors.blue,
                                letterSpacing: 1.6,
                              ),
                            ),
                            widget.products['sellerUid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      context
                                                  .read<WishList>()
                                                  .getWishItem
                                                  .firstWhereOrNull((product) =>
                                                      product.documentId ==
                                                      widget.products[
                                                          'productid']) !=
                                              null
                                          ? context.read<WishList>().removeThis(
                                              widget.products['productid'])
                                          : context
                                              .read<WishList>()
                                              .addWishItem(
                                                  widget
                                                      .products['productname'],
                                                  widget.products['price'],
                                                  1,
                                                  widget.products['instock'],
                                                  widget
                                                      .products['productimage'],
                                                  widget.products['productid'],
                                                  widget.products['sellerUid']);
                                    },
                                    icon: Provider.of<WishList>(context,
                                                    listen: true)
                                                .getWishItem
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.products[
                                                        'productid']) !=
                                            null
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_border_outlined)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Badge(
              toAnimate: true,
              shape: BadgeShape.square,
              badgeColor: Colors.cyan,
              borderRadius: BorderRadius.circular(8),
              badgeContent:
                  Text('New Arrivals', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
