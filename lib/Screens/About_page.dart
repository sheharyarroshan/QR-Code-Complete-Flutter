import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
            color: Color(0xffEF5C43),
            toolbarHeight: 70,
            elevation: 10,
            centerTitle: true),
      ),
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: const Text("About FA Technologies"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xffEF5C43),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Text(
                  "FinAstra Technologies, a leading software development company, has recently created a cutting-edge QR code app that provides both scanning and generating capabilities. With this app, users can scan QR codes with their device's camera to quickly access information or websites, and they can also generate their own QR codes to share information or links with others. The app's user-friendly interface and fast processing speed make it an excellent choice for businesses, organizations, and individuals looking for an efficient and effective QR code solution. FinAstra Technologies is committed to providing innovative solutions that make life easier and more efficient, and their latest QR code app is a testament to their expertise and commitment to excellence.",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
