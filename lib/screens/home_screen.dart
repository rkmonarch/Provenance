import 'dart:async';
import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trust_chain/bloc/bloc/product_bloc.dart';
import 'package:trust_chain/resources/ui_helpers.dart';
import 'package:trust_chain/screens/stepper.dart';

final codeStream = StreamController<Barcode>.broadcast();
var barcode = "";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String barcodeScanRes = '';

class _HomeScreenState extends State<HomeScreen> {
  final _torchIconState = ValueNotifier(false);
  Future<String> scanBarcodeNormal() async {
    String barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#00ccbb', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        barcodeScanRes = barcode;
      });
      lg.wtf(barcodeScanRes);
      if (barcodeScanRes.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    stepperPage(title: "", productID: barcodeScanRes)));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    return barcodeScanRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Scan product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _torchIconState,
            builder: (context, state, _) => IconButton(
              icon: state
                  ? const Icon(Icons.flash_on)
                  : const Icon(Icons.flash_off),
              onPressed: () async {
                await CameraController.instance.toggleTorch();
                _torchIconState.value =
                    CameraController.instance.state.torchState;
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              scanBarcodeNormal();
            },
            child: Text("Scan ME")),
      ),

      //  BarcodeCamera(
      //   types: const [
      //     BarcodeType.ean8,
      //     BarcodeType.ean13,
      //     BarcodeType.code128,
      //     BarcodeType.qr
      //   ],
      //   resolution: Resolution.hd720,
      //   framerate: Framerate.fps30,
      //   mode: DetectionMode.pauseVideo,
      //   position: CameraPosition.back,
      //   onScan: (code) {
      //     lg.d(code.value);
      //     BlocProvider.of<ProductBloc>(context)
      //         .add(ProductLoadEvent(productID: code.value));
      //     codeStream.add(code);
      //   },
      //   children: [
      //     const MaterialPreviewOverlay(animateDetection: false),
      //     const BlurPreviewOverlay(),
      //     Positioned(
      //       bottom: 50,
      //       left: 0,
      //       right: 0,
      //       child: Column(
      //         children: [
      //           ElevatedButton(
      //             child: const Text("Scan Again"),
      //             onPressed: () => CameraController.instance.resumeDetector(),
      //           ),
      //           const SizedBox(height: 20),
      //           // DetectionsCounter(
      //           //   retailerID: widget.retailerID,
      //           // )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

// ignore: must_be_immutable
class DetectionsCounter extends StatefulWidget {
  // String retailerID;
  DetectionsCounter({
    Key? key,
  }) : super(key: key);

  @override
  _DetectionsCounterState createState() => _DetectionsCounterState();
}

class _DetectionsCounterState extends State<DetectionsCounter> {
  String productID = '';
  @override
  void initState() {
    super.initState();
    lg.d("Fs");
    _streamToken = codeStream.stream.listen((event) {
      final count = detectionCount.update(event.value, (value) => value + 1,
          ifAbsent: () => 1);
      detectionInfo.value = "${count}x\n${event.value}";
      // setState(() {
      //   productID = event.value;
      // });
    });
  }

  late StreamSubscription _streamToken;
  Map<String, int> detectionCount = {};
  final detectionInfo = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        child: ValueListenableBuilder(
            valueListenable: detectionInfo,
            builder: (context, dynamic info, child) => Center(
                    child: BlocListener<ProductBloc, ProductState>(
                  listener: (context, state) {
                    lg.e("State is $state");
                    if (state is ProductSuccess) {
                      lg.wtf(state.model.name);
                    }
                  },
                  child: Container(
                      width: deviceWidth(context) * 0.9,
                      height: deviceHeight(context) * 0.11,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth(context) * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vSpaceSmall(context),
                            Text(
                              "Nike Adapt BB",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: deviceWidth(context) * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: deviceWidth(context) * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                vSpaceSmall(context),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => stepperPage(
                                                title: "title",
                                                productID: productID)));
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                )
                              ],
                            ),
                            vSpaceSmall(context)
                          ],
                        ),
                      )),
                ))));
  }
  // else if (state is ProductSuccess &&
  //     state.model.description != null) {
  //   lg.wtf("message");
  //   return Container(
  //       width: deviceWidth(context) * 0.9,
  //       height: deviceHeight(context) * 0.11,
  //       decoration: BoxDecoration(
  //         color: Colors.red,
  //         borderRadius: BorderRadius.all(Radius.circular(15)),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: deviceWidth(context) * 0.03,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             vSpaceSmall(context),
  //             Text(
  //               "Error",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: deviceWidth(context) * 0.07,
  //                 fontWeight: FontWeight.normal,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text(
  //               "No product found for this barcode, Scan again with proper barcode",
  //               style: TextStyle(
  //                   fontSize: deviceWidth(context) * 0.04,
  //                   fontWeight: FontWeight.normal,
  //                   color: Colors.white),
  //             ),
  //             vSpaceSmall(context),
  //           ],
  //         ),
  //       ));
  //

  @override
  void dispose() {
    _streamToken.cancel();
    super.dispose();
  }
}

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
