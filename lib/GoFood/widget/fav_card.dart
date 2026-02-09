import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';

class FavCard extends StatelessWidget {
  final MealModel mealModel;
  final void Function()? onTap;
  FavCard({super.key, required this.mealModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 30,
        child: SizedBox(
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      mealModel.img,
                      height: constraints.maxWidth * 0.25,
                    ),
                    SizedBox(width: constraints.maxWidth * 0.05),
                    SizedBox(
                      width: constraints.maxWidth * 0.30,
                      child: FittedBox(child: Text(mealModel.name)),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: constraints.maxWidth * 0.10,
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
