import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/nav_bar.dart';
import 'package:go_food/GoFood/widget/custom_text_field.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<RegisterLogin> createState() => _FormClassState();
}

bool passOff = true;
bool isLogin = true;

class _FormClassState extends State<RegisterLogin> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login screen" : "Rigster")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              CustomTextField(
                validator: (value) {
                  if (!(checkEmail(value!))) {
                    return "this email not valid";
                  } else {
                    return null;
                  } //true
                },
                hint: "Email@example.com",
                keyType: TextInputType.emailAddress,
                lbl: "Email",
                preIcon: Icons.email,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hint: "****",
                lbl: "password",
                keyType: TextInputType.text,
                preIcon: Icons.password,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      passOff = !passOff;
                    });
                  },
                  child: passOff
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                ),
                obscure: passOff,
              ),
              SizedBox(height: 20),
              isLogin
                  ? Text("")
                  : CustomTextField(
                      keyType: TextInputType.text,
                      hint: "*******",
                      lbl: "confirm password",
                      preIcon: Icons.password,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passOff = !passOff;
                          });
                        },
                        child: passOff
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      obscure: passOff,
                    ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => NavBar()),
                      (route) => false,
                    );
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(isLogin ? "login" : "Rigster"),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account? "
                        : "Already have an account?",
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? "Rigster Now!" : "Login!",
                      style: TextStyle(fontWeight: .bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkEmail(String email) {
    String pattern =
        r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$';
    return RegExp(pattern).hasMatch(email);
  }
}
