import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile", style: TextStyle(fontSize: 20.sp)),

            20.verticalSpacingDiameter,

            Container(height: 100.w, width: 100.w, color: Colors.purple),

            ElevatedButton(
              onPressed: () => context.push("/settings"),
              child: Text("go to home"),
            ),
          ],
        ),
      ),
    );
  }
}
