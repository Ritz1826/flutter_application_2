import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("home layout")),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,

        // currentIndex: 0,
        onTap: (index) {
          navigationShell.goBranch(index);
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: "Data"),

          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: "Animations",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.man), label: "profile"),
        ],
      ),
    );
  }
}
