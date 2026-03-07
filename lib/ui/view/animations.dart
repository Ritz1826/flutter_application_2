import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AnimationsView extends StatefulWidget {
  const AnimationsView({super.key});

  @override
  State<AnimationsView> createState() => _AnimationsViewState();
}

class _AnimationsViewState extends State<AnimationsView>
    with SingleTickerProviderStateMixin {
  double height = 100;
  double width = 100;
  AlignmentGeometry x = AlignmentGeometry.topLeft;
  double y = 1;

  late AnimationController _animController;
  late Animation<Color?> myAnimation;

  late Animation<double> myAnimation2;

  int text = 0;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    myAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.blue,
    ).animate(_animController);

    myAnimation2 = Tween(begin: 0.0, end: 200.0).animate(_animController);

    _animController.forward();

    _animController.repeat();

    Timer.periodic(Duration(seconds: 1), (Timer) {
      _animController.repeat();
      print(Timer.tick);
      if (height == 100) {
        setState(() {
          height = 200;
          width = 200;
          y = 0;
          x = AlignmentGeometry.bottomRight;
        });
      } else {
        setState(() {
          height = 100;
          width = 100;
          y = 1;
          x = AlignmentGeometry.topLeft;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animations")),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => context.push("/settings"),
            child: Center(
              child: Hero(
                tag: "hey1",
                child: Lottie.asset(
                  'assets/animations/Aeroplane.json',
                  height: 100,
                  width: 200,
                ),
              ),
            ),
          ),

          Container(
            //transform: Matrix4.rotationZ(myAnimation2.value / 1000),

            // duration: Duration(seconds: 1),
            //height: height,
            // width: width,
            height: 200,
            width: 200,
            //  color: myAnimation.value,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return Transform.scale(child: child, scale: animation.value);
              },

              switchInCurve: Curves.easeIn,
              child: Text(
                text.toString(),
                key: ValueKey(text),
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),

          GestureDetector(
            onTap: () => setState(() {
              text++;
            }),
            child: AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: myAnimation2,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
