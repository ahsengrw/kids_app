import 'package:flutter/material.dart';

import 'constants.dart';

class LoadingButton extends StatelessWidget {
  final Color? color;
  final double? width, height;
  const LoadingButton({
    Key? key,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 47,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? customYellow,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.transparent, width: 1),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
