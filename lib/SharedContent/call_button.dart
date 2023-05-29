import 'package:flutter/material.dart';

import 'constants.dart';

class CallButton extends StatelessWidget {
  final Color? buttonColor, iconColor;
  final VoidCallback onTap;
  const CallButton({
    super.key,
    this.buttonColor,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 21),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: buttonColor ?? customRed,
          child: Icon(
            Icons.call,
            size: 32,
            color: iconColor ?? Colors.brown,
          ),
        ),
      ),
    );
  }
}
