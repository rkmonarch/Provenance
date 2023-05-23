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
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        
        title: const Text(
          'Scan product',
        ),
        elevation: 1.50,
      
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          vSpaceLarge(context),
          vSpaceMassive(context),
          Image.asset("assets/Images/scanner.png",height: deviceHeight(context)*0.4,
          width: deviceWidth(context)*2,
          ),
          vSpaceMedium(context),

          Text(
            "Scan the product barcode to get started",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          vSpaceSmall(context),

          Text(
            "You can find the barcode on the product packaging",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          vSpaceMedium(context),
          vSpaceMedium(context),
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade300),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: (){
            scanBarcodeNormal();
          }, child: Text("Scan Barcode",style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          
          ),))
        ],

      )
    
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
 

  @override
  void dispose() {
    _streamToken.cancel();
    super.dispose();
  }
}

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
