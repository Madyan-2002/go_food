import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_food/GoFood/screens/nav_bar.dart';
import 'package:go_food/GoFood/widget/custom_text_field.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<RegisterLogin> createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  // Moved inside state to keep things encapsulated
  bool passOff = true;
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login Screen" : "Register")),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Email Field ---
                  CustomTextField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || !checkEmail(value)) {
                        return "This email is not valid";
                      }
                      return null;
                    },
                    hint: "Email@example.com",
                    keyType: TextInputType.emailAddress,
                    lbl: "Email",
                    preIcon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  // --- Password Field ---
                  CustomTextField(
                    controller: passwordController,
                    hint: "****",
                    lbl: "Password",
                    keyType: TextInputType.text,
                    preIcon: Icons.lock,
                    obscure: passOff,
                    suffixIcon: IconButton(
                      // Better than InkWell for icons
                      onPressed: () => setState(() => passOff = !passOff),
                      icon: Icon(
                        passOff ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Confirm Password Field (Visible only on Register) ---
                  if (!isLogin) ...[
                    CustomTextField(
                      controller: confirmPasswordController,
                      keyType: TextInputType.text,
                      hint: "*******",
                      lbl: "Confirm Password",
                      preIcon: Icons.lock_reset,
                      obscure: passOff,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                  ],

                  // --- Submit Button ---
                  ElevatedButton(
                    onPressed: _handleAuth,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(isLogin ? "Login" : "Register"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isLogin) ...[
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR", style: TextStyle(color: Colors.grey)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                         
                          signInWithGoogle(); 
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJg75LWB1zIJt1VTZO7O68yKciaDSkk3KMdw&s',
                            height: 25,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.black87, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],

                  
                  const SizedBox(height: 20),

                  // --- Switch Between Login/Register ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? "Don't have an account? "
                            : "Already have an account? ",
                      ),
                      GestureDetector(
                        onTap: () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin ? "Register Now!" : "Login!",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      String result;
      if (isLogin) {
        result = await login(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        result = await signUP(
          emailAddress: emailController.text,
          password: passwordController.text,
        );
      }

      if (result == 'done') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavBar()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  bool checkEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<String> signUP({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await FirebaseAuth.instance.signOut();
      return 'done';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'done';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    }
  }

  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
}
