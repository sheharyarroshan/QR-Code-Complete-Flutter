import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code/Admob/Ads_helper.dart';
import 'package:qr_code/Screens/About_page.dart';
import 'package:qr_code/Screens/qr_generate.dart';
import 'package:qr_code/Widgets/DrawerBox.dart';
import 'package:qr_code/Widgets/button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'qr_scanner.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
            color: Color(0xffEF5C43), toolbarHeight: 80, elevation: 10),
      ),
      child: Scaffold(
        drawer: SingleChildScrollView(
          child: SizedBox(
            height: 350,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              child: Drawer(
                backgroundColor: Color(0xffEF5C43),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/app_icon.png",
                            height: 70,
                            width: 70,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'QR Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            DisplayBox2(
                              heading: 'About Us',
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text(
                        'Designed & Created By FinAstra Technologies',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            children: [
              Image.asset(height: 45, width: 45, "assets/app_icon.png"),
              const SizedBox(width: 15),
              const Text(
                'QR Code',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
          actions: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: nMboxInvert,
                      child: const Text(
                        'i',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Georgia",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //todo logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  'assets/qr_code_logo.png',
                  height: 300,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              //todo Game title
              Text(
                "QR Code",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Text(
                "Scan and Generate",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(flex: 1),

              //todo generate button
              MyButton(
                text: "Generate QR",
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRGenerate(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.qr_code_scanner_outlined,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              //todo scan button
              MyButton(
                text: "Scan QR",
                onPressed: () {
                  HapticFeedback.vibrate();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.qr_code_scanner_outlined,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 2),
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.black,
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Colors.green,
        size: 30,
      ),
      title: const Text(
        "How to use?",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      content: const Text(
        "To use a QR code app that has both a scanner and generator, simply launch the app, switch between the scanner and generator functions as needed, and use the device's camera to scan QR codes or generate and save new QR codes for sharing.",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Center(child: okButton),
      ],
      backgroundColor: const Color(0xffEF5C43),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
