import 'package:flutter/material.dart';
import 'package:rentkars/categories/men_category.dart';
import 'package:rentkars/categories/woman_category.dart';

import 'package:rentkars/widgets/fake_search.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final PageController _pageController = PageController();
  List<ItemsData> _items = [
    ItemsData(label: 'Men'),
    ItemsData(label: 'Woman'),
    ItemsData(label: 'Shoes'),
    ItemsData(label: 'bags'),
    ItemsData(label: 'electronics'),
    ItemsData(label: 'accessories'),
    ItemsData(label: 'Kids'),
    ItemsData(label: 'Home and gurden'),
    ItemsData(label: 'Beauty'),
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: sideNavigator(size),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: categoryView(size),
        ),
      ]),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.bounceIn);
            },
            child: Container(
              color: _items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              height: 100,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _items[index].label,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
        height: size.height * 0.8,
        width: size.width * 0.8,
        color: Colors.white,
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              for (var element in _items) {
                element.isSelected = false;
              }
              setState(() {
                _items[value].isSelected = true;
              });
            });
          },
          scrollDirection: Axis.vertical,
          children: [
            MenCategory(),
            WomanCategory(),
            Center(
              child: Text('Shoes Category'),
            ),
            Center(
              child: Text('Bag Category'),
            ),
            Center(
              child: Text('Electronics Category'),
            ),
            Center(
              child: Text('accessories Category'),
            ),
            Center(
              child: Text('Kids Category'),
            ),
            Center(
              child: Text('Home and gurden'),
            ),
            Center(
              child: Text('Beauty Category'),
            ),
          ],
        ));
  }
}

class ItemsData {
  final String label;
  bool isSelected;

  ItemsData({required this.label, this.isSelected = false});
}
