import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/screens/details_screen.dart';
import 'package:go_food/GoFood/widget/category_widget.dart';
import 'package:go_food/GoFood/widget/item_card.dart';

class HomeScreen extends StatefulWidget {
  final List<MealModel> cart;
  HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String selctedItem = 'All';
String searchText = '';

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // final textFactor = MediaQuery.of(context).textScaler;
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    List<String> categories = ["All", "Burger", "Frise", "Salad"];

    List<MealModel> filtterList = meals.where((meal) {
      final searchInCategory =
          selctedItem == 'All' || meal.category == selctedItem;
      final searchByUser = meal.name.toLowerCase().contains(searchText);
      return searchInCategory && searchByUser;
    }).toList();

    //  selctedItem == 'All'
    //     ? meals
    //     : meals.where((meal) => meal.category == selctedItem).toList();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(10, 10),
                      blurRadius: 30,
                    ),
                  ],
                ),
                width: width * 0.70,
                child: Center(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                  ),
                ),
              ),

              Container(
                width: width * 0.14,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xCDfd4754),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 30,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
                child: Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          SizedBox(
            height: isLandScape ? height * 0.15 : height * 0.06,
            child: ListView.builder(
              shrinkWrap: true,

              itemExtent: 100,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => CategoryWidget(
                txtColor: selctedItem == categories[index]
                    ? Colors.white
                    : Colors.black,
                onTap: () {
                  setState(() {
                    selctedItem = categories[index];
                  });
                },
                colorBg: selctedItem == categories[index]
                    ? Color(0xCDfd4754)
                    : Colors.white,
                text: categories[index],
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: GridView.builder(
              itemCount: filtterList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandScape ? 3 : 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          mad: filtterList[index],
                          cart: widget.cart,
                        ),
                      ),
                    );
                  },
                  child: ItemCard(
                    mealModel: filtterList[index],
                    onTap: () {
                      setState(() {
                        meals[index] = filtterList[index].copyWith(
                          isFav: !filtterList[index].isFav,
                        );
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
