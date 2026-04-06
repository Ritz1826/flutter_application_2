import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view/helpers/notif_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhoneSignupScreen extends StatefulWidget {
  const PhoneSignupScreen({super.key});

  State<PhoneSignupScreen> createState() => _PhoneSignupScreenState();
}

class _PhoneSignupScreenState extends State<PhoneSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController phoneNumController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  bool isOtpSent = false;

  String gotVerificationId = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("*Sign up by phone number")),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final fbAuth = FirebaseAuth.instance;

                  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

                  await googleSignIn.initialize();

                  try {
                    final account = await googleSignIn.authenticate();

                    if (account == null) return;

                    final auth = await account.authentication;

                    final credential = GoogleAuthProvider.credential(
                      // accessToken: auth.idToken,
                      idToken: auth.idToken,
                    );

                    final user = await fbAuth.signInWithCredential(credential);

                    print(user.user?.displayName.toString());

                    print(user.user?.phoneNumber);

                    print(user.user?.email);
                  } catch (e) {
                    print("*** g error " + e.toString());
                  }
                },
                child: Text("sign in by google"),
              ),

              ElevatedButton(
                onPressed: () async {
                  await NotifService().checkPerm();

                  await Future.delayed(Duration(seconds: 1));

                  try {
                    print("notif triggered");
                    await NotifService().showNotif();
                    print("notif triggered 1");
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("try"),
              ),

              TextFormField(
                controller: phoneNumController,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  prefixIcon: Icon(Icons.phone),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                ],

                validator: (value) {
                  final RegExp phnRegex = RegExp(r'^[0-9+]');

                  if (phnRegex.hasMatch(value ?? "") &&
                      (value?.length ?? 0) < 15) {
                    return null;
                  } else {
                    return "Enter valid phone number";
                  }
                },
              ),

              SizedBox(height: 40),

              isOtpSent
                  ? TextFormField(
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
                    )
                  : SizedBox.shrink(),

              SizedBox(height: 50),

              SizedBox(height: 80),

              isOtpSent
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(),

                      onPressed: () {
                        FirebaseAuth _auth = FirebaseAuth.instance;

                        if (_formKey.currentState?.validate() ?? false) {
                          FirebaseAuth _auth = FirebaseAuth.instance;
                          final credentials = PhoneAuthProvider.credential(
                            verificationId: gotVerificationId,
                            smsCode: otpController.text,
                          );

                          _auth.signInWithCredential(credentials).then((x) {
                            Fluttertoast.showToast(
                              msg: "logged in successfully",
                            );

                            context.pushNamed("/profile");
                          });
                        }
                      },
                      child: Text("Verify Otp"),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(),

                      onPressed: () {
                        FirebaseAuth _auth = FirebaseAuth.instance;

                        if (_formKey.currentState?.validate() ?? false) {
                          _auth.verifyPhoneNumber(
                            phoneNumber: phoneNumController.text,
                            verificationCompleted: (phoneAuthCredential) {
                              Fluttertoast.showToast(
                                msg: "verification Completed",
                              );
                            },
                            verificationFailed: (error) {
                              print("*******");
                              print(error.message.toString());
                              Fluttertoast.showToast(
                                msg: error.message.toString(),
                              );
                              context.goNamed("phonesignup");
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              // gotVerificationId = verificationId;

                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              // if (!mounted) return;

                              context.goNamed(
                                "otpscreen",
                                extra: verificationId,
                              );
                              Fluttertoast.showToast(msg: "verif codeSent");
                              //  });
                            },
                            codeAutoRetrievalTimeout: (verificationId) {
                              Fluttertoast.showToast(
                                msg: "verif codeAutoRetrievalTimeout",
                              );
                            },
                          );
                        }
                      },
                      child: Text("Send otp"),
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
