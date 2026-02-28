import 'package:cloud_firestore/cloud_firestore.dart';
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
  String uid  = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('favorite').snapshots(),
       builder: (context,snapShot) {
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if (snapShot.data!.docs.isEmpty){
            return Center(child: Text('Favorite Screen is Empty'),);
          }

          final favorite = snapShot.data!.docs.map((fav) => MealModel.fromMap(fav.data(), fav.id)).toList();
          return ListView.builder(
            itemCount: favorite.length,
            itemBuilder: (context,index) {
              return FavCard(mealModel: favorite[index] , onTap: (){
                
              });

          });
       });
    // final user = FirebaseAuth.instance.currentUser;
    // List<MealModel> favMeals = meals
    //     .where((meal) => meal.isFav == true)
    //     .toList();
     
    // return favMeals.isEmpty
    //     ? SizedBox(
    //         width: double.infinity,
    //         child: Column(
    //           mainAxisAlignment: .center,
    //           crossAxisAlignment: .center,
    //           children: [
    //             Icon(
    //               Icons.favorite_outline_sharp,
    //               size: 70,
    //               color: Colors.grey,
    //             ),
    //             SizedBox(height: 30),
    //             Text(
    //               'Fav is Empty',
    //               style: TextStyle(
    //                 fontFamily: 'font2',
    //                 fontSize: 22,
    //                 color: Colors.grey,
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     :ListView.builder(
    //   itemCount: favMeals.length,
    //   itemBuilder: (context, index) {
    //     return FavCard(
    //       mealModel: favMeals[index],
    //       onTap: () {
    //         setState(() {
    //           int indexOfMeal = meals.indexWhere(
    //             (meal) => meal.name == favMeals[index].name,
    //           );
    //           meals[indexOfMeal] = meals[indexOfMeal].copyWith(isFav: false);
    //         });
    //       },
    //     );
    //   },
    // );
  }
}
