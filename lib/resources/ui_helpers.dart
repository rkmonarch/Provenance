import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:trust_chain/screens/home_screen.dart';

Logger lg = Logger();

 Widget hSpaceTiny(BuildContext context) => SizedBox(width: deviceWidth(context)*0.001);
 Widget hSpaceSmall(BuildContext context) => SizedBox(width: deviceWidth(context)*0.01);
 Widget hSpaceMedium(BuildContext context) => SizedBox(width: deviceWidth(context)*0.03);
 Widget hSpaceLarge(BuildContext context) => SizedBox(width: deviceWidth(context)*0.05);
 Widget hSpaceMassive(BuildContext context) => SizedBox(width:  deviceWidth(context)*0.1);

Widget vSpaceTiny(BuildContext context) =>
    SizedBox(height: deviceHeight(context) * 0.001);
Widget vSpaceSmall(BuildContext context) =>
    SizedBox(height: deviceHeight(context) * 0.01);
Widget vSpaceMedium(BuildContext context) =>
    SizedBox(height: deviceHeight(context) * 0.03);
Widget vSpaceLarge(BuildContext context) =>
    SizedBox(height: deviceHeight(context) * 0.05);
Widget vSpaceMassive(BuildContext context) =>
    SizedBox(height: deviceHeight(context) * 0.1);
