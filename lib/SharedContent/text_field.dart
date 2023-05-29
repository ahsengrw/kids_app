import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final dynamic onChanged;
  final String? hintText;
  final dynamic validation;
  final dynamic prefixIcon;
  final dynamic maxLines;
  final dynamic minLines;
  final String? initialValue;
  final dynamic keyBoardType;
  final dynamic controller;
  CustomTextField(
      {Key? key,
      this.controller,
      this.keyBoardType,
      this.hintText,
      this.prefixIcon,
      this.initialValue,
      this.onChanged,
      this.maxLines,
      this.minLines,
      this.validation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validation,
      onChanged: onChanged,
      controller: controller,
      // textAlign: TextAlign.center,
      maxLines: maxLines ?? 1,
      initialValue: initialValue ?? '',
      keyboardType: keyBoardType ?? TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        fillColor: Color(0xffE6E6E6),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        prefixIcon: prefixIcon,
        border: InputBorder.none,
        hintText: hintText,
      ),
    );
  }
}
