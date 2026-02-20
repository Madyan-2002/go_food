import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/admin_screen.dart';
import 'package:go_food/GoFood/screens/nav_bar.dart';
import 'package:go_food/GoFood/screens/splash_screen.dart';
import 'package:go_food/GoFood/styles/color_class.dart';
import 'package:go_food/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoFooD',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorClass.headLines,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorClass.primary,
            foregroundColor: ColorClass.headLines,
          ),
        ),
        appBarTheme: AppBarThemeData(
          backgroundColor: ColorClass.primary,
          foregroundColor: ColorClass.headLines,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: ColorClass.headLines,
          unselectedItemColor: Colors.white70,
          backgroundColor: ColorClass.primary,
          type: BottomNavigationBarType.fixed,
        ),
        iconTheme: IconThemeData(color: ColorClass.headLines),
      ),
      debugShowCheckedModeBanner: false,
      home: userState(),
    );
  }

  Widget userState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // حالة التحميل أثناء التحقق من السيرفر

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: ColorClass.primary),
            ),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),

            builder: (context, roleSnapshot) {
              if (roleSnapshot.hasData) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
              final data = roleSnapshot.data!.data() as Map<String, dynamic>;
              final role = data['role'];

         //     final role = roleSnapshot.data!['role'];
         
              if (role == 'user') {
                return NavBar();
              } else if (role == 'admin') {
                return AdminScreen();
              }
              }

              return Center(child: CircularProgressIndicator(),);
            },
          );
        }

        return SplashScreen();
      },
    );
  }
}
