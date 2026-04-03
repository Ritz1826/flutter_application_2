import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String gotVerificationId;
  const OtpScreen({super.key, required this.gotVerificationId});

  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController otpController = TextEditingController();

  bool isOtpSent = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter otp")),
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
                controller: otpController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your otp",
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) {
                  if ((value?.length ?? 0) == 6) {
                    return null;
                  } else {
                    return "Enter correct otp";
                  }
                },
              ),

              SizedBox(height: 80),

              ElevatedButton(
                style: ElevatedButton.styleFrom(),

                onPressed: () async {
                  FirebaseAuth _auth = FirebaseAuth.instance;

                  if (_formKey.currentState?.validate() ?? false) {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    print(
                      "verificationIdverificationId ${widget.gotVerificationId}",
                    );
                    final credentials = PhoneAuthProvider.credential(
                      verificationId: widget.gotVerificationId,
                      smsCode: otpController.text.trim(),
                    );

                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(credentials)
                          .then((x) {
                            if (mounted) {
                              context.pushNamed("profile");
                            }

                            Fluttertoast.showToast(
                              msg: "logged in successfully",
                            );
                          });
                    } on FirebaseAuthException catch (e) {
                      print("heyyy " + (e.message ?? "") + e.code);

                      if (e.code == 'invalid-verification-code') {
                        Fluttertoast.showToast(
                          msg: 'Incorrect OTP. Please try again.',
                        );
                      } else if (e.code == 'session-expired') {
                        Fluttertoast.showToast(
                          msg: 'OTP expired. Please request a new one.',
                        );
                        // Navigate back to phone number screen
                      }
                    }
                  }
                },
                child: Text("Verify Otp"),
              ),

              SizedBox(height: 180),

              TextButton(
                onPressed: () {
                  context.goNamed("signup");
                },
                child: Text("Sign up with email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
