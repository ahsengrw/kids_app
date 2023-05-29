import 'package:flutter/material.dart';

import 'constants.dart';

class LogoReuse extends StatelessWidget {
  final double? width, height;
  const LogoReuse({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? 217,
        height: height ?? 158,
        child: Image.asset(logoUrl),
      ),
    );
  }
}
