import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/screens/cart_screen.dart';
import 'package:go_food/GoFood/screens/fav_screen.dart';
import 'package:go_food/GoFood/screens/home_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // 1. القائمة تبقى هنا
  List<MealModel> cart = [];
  int index = 0;

  // 2. المعلومات الأساسية للأيقونات تبقى هنا
  Map<String, dynamic> infoForScreen = {
    'Home': const Icon(Icons.home),
    'Favorite': const Icon(Icons.favorite),
    'Cart': const Icon(Icons.shopping_cart),
  };

  @override
  Widget build(BuildContext context) {
    // 3. الحل: تعريف قائمة الشاشات داخل الـ build لتتمكن من الوصول لـ cart
    final List<Widget> screens = [
      HomePage(cart: cart),
      const FavPage(),
      CartPage(cart: cart),
    ];

    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        // إزالة الفراغ السفلي في وضع الـ Landscape
        bottom: isLandScape
            ? null
            : const PreferredSize(
                preferredSize: Size(double.infinity, 35),
                child: SizedBox(),
              ),
        title: ListTile(
          title: const Text(
            "GoFooD",
            style: TextStyle(
              fontFamily: 'font2',
              fontSize: 30,
              fontWeight: FontWeight.bold, // تصحيح من .bold
              color: Colors.white,
            ),
          ),
          subtitle: const Text("Your favorite food"),
          trailing: const CircleAvatar(backgroundColor: Colors.white),
        ),
      ),
      // 4. عرض الشاشة بناءً على الاندكس الحالي
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          // تحديث الحالة عند الضغط على أيقونة
          setState(() {
            index = value;
          });
        },
        items: infoForScreen.entries
            .map((i) => BottomNavigationBarItem(icon: i.value, label: i.key))
            .toList(),
      ),
    );
  }
}
