import 'package:flutter/material.dart';
import 'package:tf_test/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
