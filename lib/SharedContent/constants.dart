import 'package:flutter/material.dart';

const Color lightGreen = Color(0xffA8EABC);
const Color darkGreen = Color(0xff97C33C);
const Color customYellow = Color(0xffF4CB4E);
const Color darkBlue = Color(0xff3B90F7);
const Color lightBlue = Color(0xff74DBD7);
const Color darkBrown = Color(0xffED702D);
const Color redishOrange = Color(0xffE76F51);
const Color darkPurple = Color(0xff264653);
const Color customRed = Colors.red;
const Color brown3 = Color(0xff463b20);
const Color lightBrown = Color(0xffF4A261);
const Color yellowish = Color(0xffE9C46A);

const String logoUrl = 'assets/splashscreen.gif';

const TextStyle customHeadingStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

const TextStyle customStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

showToast(
  BuildContext context,
  String content,
) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

BoxDecoration dropdownDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(9),
  color: Colors.white,
  border: Border.all(color: Colors.grey, width: 1),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.7),
      blurRadius: 7,
      offset: Offset(0, 4), // Shadow position
    ),
  ],
);
