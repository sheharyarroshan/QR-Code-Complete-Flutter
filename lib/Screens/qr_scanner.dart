import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code/Admob/Ads_helper.dart';
import 'package:qr_code/Screens/qr_screen_result.dart';
import 'package:qr_code/Widgets/tool.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  //* qr scan transaction
  bool isScanComplete = false;

  //* flash bool
  bool isFlash = false;

  //* cam bool
  bool isCam = false;

  //* toggle flash controller
  MobileScannerController controller2 = MobileScannerController();

  //* change page
  void closeScanner() {
    setState(() {
      isScanComplete = false;
    });
  }

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose a RewardedAd object
    // TODO: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
            color: Color(0xffEF5C43), toolbarHeight: 60, elevation: 10),
      ),
      child: Scaffold(
        //* app bar
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            'QR Scanner',
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
        ),

        //* body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              //* Body title
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Place your QR code here",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "Scanned Automatically",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),

              //* Camera Container
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: QrCamera(
                    key: qrKey,
                    qrCodeCallback: (code) {
                      if (code != null && !isScanComplete) {
                        setState(() {
                          isScanComplete = true;
                        });
                        String qrResult = code.code;
                        if (isScanComplete) {
                          _interstitialAd?.show();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrResultPage(
                              closeScreen: closeScanner,
                              qrResult: qrResult,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Center(child: Text('Scan QR code')),
                  ),
                ),
              ),

              //* Tools Container
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //* flash toggle
                    MyTool(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        setState(() {
                          isFlash = !isFlash;
                        });
                        controller?.toggleFlash();
                      },
                      text: "Flash",
                      icon: Icon(
                        Icons.flash_on,
                        color: isFlash ? Colors.yellow : Colors.white,
                      ),
                    ),

                    //* camera toggle
                    MyTool(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        setState(() {
                          isCam = !isCam;
                        });
                        //controller?.switchCamera();
                      },
                      text: "Camera",
                      icon: const Icon(
                        Icons.switch_camera_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
