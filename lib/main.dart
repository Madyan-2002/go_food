import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/nav_bar.dart';
import 'package:go_food/GoFood/screens/register_login_screen.dart';
import 'package:go_food/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoFooD',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xCDfe210e),
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Color(0xCDfe210e),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Color(0xCDfe210e),
          type: BottomNavigationBarType.fixed,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xCDfe210e)),
            ),
          );
        }
        // إذا وجد مستخدم مسجل دخول، يتم توجيهه للـ NavBar (الذي يحتوي على Scaffold)
        else if (snapshot.hasData) {
          return const NavBar(); //
        }
        // إذا لم يوجد مستخدم، يتم توجيهه لشاشة تسجيل الدخول
        return const RegisterLogin();
      },
    );
  }
}