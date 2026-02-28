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

      // أثناء التحقق من تسجيل الدخول
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // إذا لم يكن هناك مستخدم مسجل دخول
      if (!snapshot.hasData) {
        return SplashScreen();
      }

      // إذا كان هناك مستخدم
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data!.uid)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> roleSnapshot) {

          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (roleSnapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error loading user data")),
            );
          }

          // إذا وُجد document للمستخدم
          if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
            final data =
                roleSnapshot.data!.data() as Map<String, dynamic>;
            final role = data['role'];

            if (role == 'user') {
              return NavBar();
            } else if (role == 'admin') {
              return AdminScreen();
            }
          }

          // إذا لا يوجد document
          return SplashScreen();
        },
      );
    },
  );
}
}
