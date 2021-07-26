import 'package:book_my_slot/models/session.dart';
import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final String? text;
  Color? bgColor = Colors.blueAccent;
  CustomCardWidget({required this.text,this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: bgColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          "$text",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
