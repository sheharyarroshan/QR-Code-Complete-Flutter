import 'package:flutter/material.dart';
import 'package:qr_code/Screens/About_page.dart';

class DisplayBox2 extends StatelessWidget {
  late String heading;

  DisplayBox2({required this.heading, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
      },
      child: Container(
        decoration: nMboxInvert,
        height: 45,
        width: 260,
        child: Center(
          child: Text(
            heading,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration nMboxInvert = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: const Color(0xffEF5C43),
    boxShadow: const [
      BoxShadow(
          color: Colors.white,
          offset: Offset(3, 3),
          blurRadius: 6,
          spreadRadius: -3),
    ]);
