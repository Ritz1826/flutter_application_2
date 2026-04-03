import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController pwdController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign in")),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter email",
                  prefixIcon: Icon(Icons.email),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9@._+-]'),
                  ),
                ],

                validator: (value) {
                  final RegExp emailRegex = RegExp(
                    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                  );

                  if (emailRegex.hasMatch(value ?? "")) {
                    return null;
                  } else {
                    return "Enter valid email";
                  }
                },
              ),

              SizedBox(height: 40),

              TextFormField(
                controller: pwdController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) {
                  if ((value?.length ?? 0) > 5) {
                    return null;
                  } else {
                    return "Enter atleast 6 chars";
                  }
                },
              ),

              SizedBox(height: 50),

              Text.rich(
                style: TextStyle(fontSize: 11),
                TextSpan(
                  children: [
                    TextSpan(text: "Dont have an account ?"),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: TextButton(
                        onPressed: () {
                          context.goNamed("signup");
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 11,
                            decorationStyle: TextDecorationStyle.wavy,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 80),

              ElevatedButton(
                style: ElevatedButton.styleFrom(),

                onPressed: () {
                  FirebaseAuth _auth = FirebaseAuth.instance;

                  if (_formKey.currentState?.validate() ?? false) {
                    _auth
                        .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: pwdController.text,
                        )
                        .then((x) {
                          context.go("/home");
                        })
                        .onError((e, s) {
                          Fluttertoast.showToast(msg: e.toString());
                        });
                  }
                },
                child: Text("Sign In"),
              ),
              SizedBox(height: 180),
              TextButton(
                onPressed: () {
                  FirebaseAuth _auth = FirebaseAuth.instance;

                  _auth
                      .sendPasswordResetEmail(email: emailController.text)
                      .then((x) {
                        Fluttertoast.showToast(msg: "sent");
                      })
                      .onError((e, s) {
                        Fluttertoast.showToast(msg: "error ${e.toString()}");
                      });
                },
                child: Text("Forgot password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
