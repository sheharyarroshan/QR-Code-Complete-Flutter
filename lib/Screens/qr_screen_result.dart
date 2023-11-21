import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code/Admob/Ads_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Widgets/tool.dart';

class QrResultPage extends StatefulWidget {
  const QrResultPage({
    super.key,
    required this.qrResult,
    required this.closeScreen,
  });

  final String qrResult;
  final Function()? closeScreen;

  @override
  State<QrResultPage> createState() => _QrResultPageState();
}

class _QrResultPageState extends State<QrResultPage> {
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
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              widget.closeScreen!();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            "Your Result",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),

        //* body
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //* show QR image
                SizedBox(height: 70),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 5)),
                  height: 230,
                  width: 230,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QrImage(
                      foregroundColor: Color(0xffEF5C43),
                      data: widget.qrResult,
                      size: 230,
                      version: QrVersions.auto,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //* Result
                Text(
                  "Scanned QR Code:",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  widget.qrResult,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),

                const SizedBox(
                  height: 20,
                ),

                //* tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //* copy
                    MyTool(
                      icon: const Icon(Icons.copy),
                      text: "Copy",
                      onPressed: () {
                        _interstitialAd?.show();
                        setState(() {
                          _loadInterstitialAd();
                        });
                        HapticFeedback.heavyImpact();
                        Clipboard.setData(
                          ClipboardData(text: widget.qrResult),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
