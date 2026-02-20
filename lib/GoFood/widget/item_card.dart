import 'package:flutter/material.dart';
import 'package:go_food/GoFood/model/meal_model.dart';
import 'package:go_food/GoFood/styles/color_class.dart';

class ItemCard extends StatelessWidget {
  final MealModel mealModel;
  final void Function()? onTap;
  const ItemCard({super.key, required this.mealModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(color: ColorClass.headLines,
    elevation: 15,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Expanded(child: Image.asset(mealModel.img, height: 120)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mealModel.name,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(fontWeight: .bold),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,

                    child: Text("${mealModel.price} \$"),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: InkWell(
              onTap: onTap,
              child: mealModel.isFav
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_outline, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
