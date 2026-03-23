import 'package:flutter/material.dart';

class UserImages extends StatefulWidget {
  const UserImages({super.key});

  @override
  State<UserImages> createState() => _UserImagesState();
}

class _UserImagesState extends State<UserImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images")),
      body: Text("data"),
    );
  }
}
