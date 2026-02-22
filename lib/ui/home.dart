import 'dart:async';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  StreamController<int> myStreamController = StreamController<int>();
  late Stream<int> myStream;
  int y = 0;
  late StreamSubscription z;

  @override
  void initState() {
    myStream = myStreamController.stream.asBroadcastStream();

    z = myStream.listen((onData) => print(onData.toString()));

    // StreamSubscription x = myStream.listen(
    //   (data) {
    //     print(data);
    //   },
    //   onDone: () => print("done"),
    //   onError: (x) => print("error $x"),
    // );

    Timer.periodic(Duration(seconds: 1), (x) {
      if (!myStreamController.isClosed) {
        myStreamController.add(y);
      }
      if (y > 20 && y < 22) {
        myStreamController.addError("errorrr");
      }

      if (y > 30) {
        myStreamController.close();
      }
      y++;
    });

    super.initState();
  }

  @override
  void dispose() {
    myStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => z.resume(), child: Text("resume")),
            ElevatedButton(onPressed: () => z.cancel(), child: Text("cancel")),
            ElevatedButton(onPressed: () => z.pause(), child: Text("pause")),

            StreamBuilder<int>(
              stream: myStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Text("no data");
                }
              },
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.yellowAccent,
                child: Text(MediaQuery.of(context).viewPadding.toString()),
              ),
            ),

            Container(
              height: 300,
              width: 300,
              color: Colors.grey,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                widthFactor: 0.5,
                child: Container(color: Colors.blueAccent),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              color: Colors.greenAccent,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Text(constraints.maxHeight.toString()),
                      Container(
                        color: Colors.deepOrange,
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.1,
                      ),

                      Container(
                        color: const Color.fromARGB(255, 244, 133, 99),
                        height: constraints.maxHeight * 0.3,
                        width: constraints.maxWidth * 0.3,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
