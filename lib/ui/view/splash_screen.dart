import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;

    if (user == null) {
      Timer(Duration(seconds: 3), () {
        context.goNamed("signup");
      });
    } else {
      Timer(Duration(seconds: 3), () {
        context.goNamed("signup");
      });
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Welcome")));
  }
}
