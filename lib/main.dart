import 'package:ecoalmaty/pageSelection.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFF131010),
      ),
      home: PageSelection(),
      debugShowCheckedModeBanner: false,
    );
  }
}
