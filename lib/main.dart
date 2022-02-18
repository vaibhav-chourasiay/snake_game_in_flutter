import 'package:flutter/material.dart';

import 'page/gamepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sanke Game",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: GamePage(),
    );
  }
}
