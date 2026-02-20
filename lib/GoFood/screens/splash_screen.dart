import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/register_login_screen.dart';
import 'package:go_food/GoFood/styles/color_class.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => RegisterLogin()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(205, 227, 26, 8),
                  Color(0xCDfe210e),
                  Color(0xCDff6f07),
                  Color(0xCDff7f03),
                  Color(0xCDfea202),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "GoFooD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontFamily: "splashfont",
                    fontWeight: .bold,
                  ),
                ),
                SizedBox(height: 10),
                CircularProgressIndicator(color: ColorClass.headLines, strokeWidth: 3),
              ],
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Image.asset("assets/images/b.png"),
          ),
        ],
      ),
    );
  }
}
