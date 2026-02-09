import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/widget/custom_cart.dart';

class CartPage extends StatelessWidget {
  final List<MealModel> cart;
  CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return cart.isEmpty
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Icon(
                  Icons.shopping_cart_checkout_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 30),
                Text(
                  'Cart is Empty',
                  style: TextStyle(
                    fontFamily: 'font2',
                    fontSize: 22,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return CustomCart(foodModel: cart[index]);
                  },
                ),
              ),
              Expanded(
                child: Text(
                  'Total price = ${calculateTotal(cart)}',
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
              ),
            ],
          );
  }

  calculateTotal(List<MealModel> cart) {
    double sum = 0;
    cart.forEach((meal) {
      sum += meal.price;
    });
    return sum;
  }
}
