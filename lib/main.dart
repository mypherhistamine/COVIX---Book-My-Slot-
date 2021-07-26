import 'package:book_my_slot/views/covid_pincode_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book My Slot',
      home: TesterView(),
    );
  }
}
