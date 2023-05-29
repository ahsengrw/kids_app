import 'package:flutter/material.dart';
import 'constants.dart';

class NoAppointments extends StatelessWidget {
  final String title, subtitle;
  const NoAppointments({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 13,
        ),
        Text(
          title,
          style: customStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 21,
        ),
        Text(
          subtitle,
          style: customStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
