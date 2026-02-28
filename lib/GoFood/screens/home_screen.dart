import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/styles/color_class.dart';
import 'package:go_food/GoFood/widget/category_widget.dart';
import 'package:go_food/GoFood/widget/item_card.dart';

class HomeScreen extends StatefulWidget {
  final List<MealModel> cart;

  const HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedItem = 'All';
  String searchText = '';
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    List<String> categories = ["All", "Burger", "Frise", "Salad"];

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          /// 🔎 Search Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(10, 10),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                  ),
                ),
              ),
              Container(
                width: width * 0.14,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorClass.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: height * 0.02),

          /// 🏷 Categories
          SizedBox(
            height: isLandScape ? height * 0.15 : height * 0.06,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemExtent: 100,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryWidget(
                  txtColor: selectedItem == category
                      ? Colors.white
                      : Colors.black,
                  onTap: () {
                    setState(() {
                      selectedItem = category;
                    });
                  },
                  colorBg: selectedItem == category
                      ? ColorClass.primary
                      : ColorClass.headLines,
                  text: category,
                );
              },
            ),
          ),

          SizedBox(height: height * 0.02),

          /// 🛒 Products Grid
          Expanded(
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = authSnapshot.data;

                if (user == null) {
                  return const Center(child: Text("User not logged in"));
                }

                final uid = user.uid;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, productSnapShot) {
                    if (!productSnapShot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = productSnapShot.data!.docs
                        .map(
                          (doc) => MealModel.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ),
                        )
                        .where(
                          (p) =>
                              selectedItem == 'All' ||
                              p.category == selectedItem,
                        )
                        .where((p) => p.name.toLowerCase().contains(searchText))
                        .toList();

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('favorite')
                          .snapshots(),
                      builder: (context, favSnapShot) {
                        if (!favSnapShot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final favIds = favSnapShot.data!.docs
                            .map((doc) => doc.id)
                            .toSet();

                        final productWithFav = products
                            .map(
                              (p) => p.copyWith(isFav: favIds.contains(p.id)),
                            )
                            .toList();

                        if (productWithFav.isEmpty) {
                          return const Center(child: Text("No products found"));
                        }

                        return GridView.builder(
                          itemCount: productWithFav.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final product = productWithFav[index];

                            return ItemCard(
                              mealModel: product,
                              onTap: () async {
                                if (product.isFav) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('favorite')
                                      .doc(product.id)
                                      .delete();
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('favorite')
                                      .doc(product.id)
                                      .set({
                                        'productId': product.id,
                                        'name': product.name,
                                        'image': product.img,
                                        'price': product.price,
                                        'description': product.description,
                                      });
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ❤️ Add to Favorite (يحفظ فقط الـ id)
  Future<void> productFav(MealModel product) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .doc(product.id)
        .set({'productId': product.id});
  }
}
