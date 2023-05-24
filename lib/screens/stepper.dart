import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trust_chain/Repo/product_repo.dart';
import 'package:trust_chain/bloc/bloc/product_bloc.dart';
import 'package:trust_chain/resources/ui_helpers.dart';
import 'package:trust_chain/screens/home_screen.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class stepperPage extends StatefulWidget {
  final String? productID;
  stepperPage({Key? key, required this.title, required this.productID})
      : super(key: key);

  final String title;

  @override
  _stepperPageState createState() => _stepperPageState();
}

class _stepperPageState extends State<stepperPage> {
  int groupValue = 0;
  List productDate = [];
  void getDate(String Date) {
    for (int i = 0; i <= Date.length - 8; i += 8) {
      final hex = Date.substring(i, i + 8);

      final number = int.parse(hex, radix: 16);
      print(number);
      setState(() {
        productDate.add(number);
      });
    }
  }

  StepperType _type = StepperType.horizontal;
  int _currentStep = 0;

  List<Step> _steps = [];
  int _index = 0;
  ProductModel data = ProductModel();
  List<Tuple2> tuples = [
    // Tuple2(
    //   Icons.directions_bike,
    //   StepState.indexed,
    // ),
    // Tuple2(
    //   Icons.directions_bus,
    //   StepState.editing,
    // ),
    // Tuple2(
    //   Icons.directions_railway,
    //   StepState.complete,
    // ),
    // Tuple2(
    //   Icons.directions_boat,
    //   StepState.disabled,
    // ),
    // Tuple2(Icons.directions_car, StepState.error, ),
  ];

  @override
  void initState() {
    lg.wtf("initState");
    lg.wtf(widget.productID);
    BlocProvider.of<ProductBloc>(context)
        .add(ProductLoadEvent(productID: widget.productID!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.green.shade300,
          title: Text("Product Details"),
          actions: [],
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.02),
          child: buildStepper(context),
        ),
      ),
    );
  }

  Widget buildStepper(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.02),
        child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductSuccess) {
                setState(() {
                  data = state.model;
                });
                for (var i = 0; i < state.model.locationStatuses!.length; i++) {
                  setState(() {
                    _steps.add(
                      Step(
                        title: Text(data.locationStatuses![i]),
                    state: data.locationStatuses!.length - 1 == i ? StepState.complete : StepState.indexed,
                        content: Text(data.timestamp![i]),
                        isActive: data.locationStatuses!.length - 1 == i ? true : false,
                      ),
                    );  
                  });
                }
              }
            },
            child: data.name != null
                ? Column(
                    children: [
                      vSpaceSmall(context),
                      Container(
                        height: deviceHeight(context) * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.green.shade300,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth(context) * 0.02),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: deviceWidth(context) * 0.15,
                                  child: CachedNetworkImage(
                                      imageUrl: data.imageURL!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            height: deviceWidth(context) * 0.4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))),
                              hSpaceMedium(context),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight(context) * 0.06),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    vSpaceSmall(context),
                                    Text(
                                      data.description ?? "",
                                      style: TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stepper(
                        currentStep: _currentStep,
                        steps: _steps,
                        controlsBuilder: (context, details) => SizedBox(),
                        type: StepperType.vertical,
                        onStepTapped: (step) async {
                          await launchUrl(
                              Uri.parse(data.locationURL!.elementAt(step)));
                        },
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
