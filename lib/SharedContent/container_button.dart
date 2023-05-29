import 'package:flutter/material.dart';

import 'constants.dart';

class ContainerButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color, titleColor, borderColor;
  final double? width, height, borderRadius, fontSize;
  ContainerButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.color,
    this.height,
    this.width,
    this.fontSize,
    this.titleColor,
    this.borderRadius,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 47,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? customYellow,
          borderRadius: BorderRadius.circular(borderRadius ?? 7),
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 1),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              color: titleColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
