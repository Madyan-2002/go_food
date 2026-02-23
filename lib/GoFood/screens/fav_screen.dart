import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/widget/fav_card.dart';

class FavScreen extends StatefulWidget {
  
  
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavPageState();
}

class _FavPageState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    List<MealModel> favMeals = meals
        .where((meal) => meal.isFav == true)
        .toList();
     
    return favMeals.isEmpty
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Icon(
                  Icons.favorite_outline_sharp,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 30),
                Text(
                  'Fav is Empty',
                  style: TextStyle(
                    fontFamily: 'font2',
                    fontSize: 22,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        :ListView.builder(
      itemCount: favMeals.length,
      itemBuilder: (context, index) {
        return FavCard(
          mealModel: favMeals[index],
          onTap: () {
            setState(() {
              int indexOfMeal = meals.indexWhere(
                (meal) => meal.name == favMeals[index].name,
              );
              meals[indexOfMeal] = meals[indexOfMeal].copyWith(isFav: false);
            });
          },
        );
      },
    );
  }
}
