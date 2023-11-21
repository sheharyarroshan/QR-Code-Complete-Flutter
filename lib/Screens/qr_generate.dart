import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/Admob/Ads_helper.dart';
import 'package:qr_code/Widgets/button.dart';
import 'package:qr_code/Widgets/tool.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRGenerate extends StatefulWidget {
  const QRGenerate({super.key});

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {
  int count = 1;
  int pressed = 0;
  //* text controller
  final TextEditingController _textEditingController = TextEditingController();

  //* text data to generate qr
  var data = "FinAstra Technologies";
  final _screenshotController = ScreenshotController();

  bool permissionGranted = false;

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
          appBarTheme: AppBarTheme(
              color: Color(0xffEF5C43), toolbarHeight: 60, elevation: 10)),
      child: Scaffold(
        //* app bar
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Generate QR",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),

        //* body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                //* show QR code
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black, width: 5)),
                    height: 230,
                    width: 230,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QrImage(
                        foregroundColor: Color(0xffEF5C43),
                        data: data,
                        size: 230,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 45,
                ),

                //* input field
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _textEditingController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    focusColor: Colors.brown,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    hintText: "Enter text",
                    hintStyle: Theme.of(context).textTheme.headline2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                //* generate button
                MyButton(
                  text: "Generate QR",
                  onPressed: () {
                    pressed++;
                    HapticFeedback.heavyImpact();
                    setState(() {
                      data = _textEditingController.text;
                    });

                    if (pressed == 2) {
                      if (_interstitialAd != null) {
                        _interstitialAd?.show();
                      }
                      setState(() {
                        _loadInterstitialAd();
                        pressed = 0;
                      });
                    }
                  },
                  icon: const Icon(Icons.qr_code),
                ),

                const SizedBox(
                  height: 35,
                ),

                //* tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //*save
                    /* MyTool(
                      icon: const Icon(Icons.download),
                      text: "Save",
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
    
                        final imageData = await _screenshotController.capture();
                        if (imageData == null) return;
                        SaveScreenshot2(imageData);
                      },
                    ),*/
                    //* share
                    MyTool(
                      icon: const Icon(Icons.share),
                      text: "Share",
                      onPressed: () async {
                        pressed++;
                        if (pressed == 2) {
                          if (_interstitialAd != null) {
                            _interstitialAd?.show();
                          }
                          setState(() {
                            _loadInterstitialAd();
                            pressed = 0;
                          });
                        }
                        count++;
                        HapticFeedback.heavyImpact();
                        await _screenshotController
                            .capture()
                            .then((bytes) async {
                          final Directory output =
                              await getTemporaryDirectory();
                          final String screenshotFilePath =
                              '${output.path}/image_$count.png';
                          final File screenshotFile = File(screenshotFilePath);
                          await screenshotFile.writeAsBytes(bytes!);
                          Share.shareXFiles(
                            [XFile(screenshotFilePath)],
                            text: "QR Code",
                            sharePositionOrigin: () {
                              RenderBox? box =
                                  context.findRenderObject() as RenderBox?;
                              return box!.localToGlobal(Offset.zero) & box.size;
                            }(),
                          );
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    return '$directory/qr.png';
  }

  Future<void> saveScreenshot(Uint8List imageData) async {
    final picturesDirectory = await getExternalStorageDirectory();
    final path = picturesDirectory!.path + '/Pictures';
    final directory = Directory(path);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final now = DateTime.now();
    final file = File(path + '/screenshot$now.png');

    await file
        .writeAsBytes(Uint8List.fromList(imageData!.buffer.asUint8List()));

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(imageData.buffer.asUint8List()));
  }

  Future<String> SaveScreenshot2(Uint8List image) async {
    print(image);
    final now = DateTime.now();
    final name = '/screenshot_$now';
    final result = await ImageGallerySaver.saveImage(image, name: name);

    return result['filePath'];
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }
}
