import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xCDfe210e),
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: AppBarThemeData(
          backgroundColor: Color(0xCDfe210e),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          backgroundColor: Color(0xCDfe210e),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // routes: {
      //   '/': (context) => NavScreenOne(),
      //   "/screen2": (context) => NavScreenTwo(),
      //   "/screen3": (context) => NavScreenThree(),
      // },
      //initialRoute: '/',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
