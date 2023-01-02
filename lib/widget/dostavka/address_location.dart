// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../color/color.dart';

class AddressAdd extends StatefulWidget {
  const AddressAdd(
      {Key? key,
      required this.controller,
      required this.label,
      required this.redValidator,
      required this.hintText,
      required this.prefixText,
      required this.Icon,
      required this.keyboardType,
      required this.maxLength})
      : super(key: key);
  final TextEditingController controller;
  final String label, redValidator, hintText, prefixText;
  final Icon;
  final TextInputType keyboardType;
  final int maxLength;

  @override
  State<AddressAdd> createState() => _AddressAddState();
}

class _AddressAddState extends State<AddressAdd> {
  var maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatter1 = MaskTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 6),
      padding:  EdgeInsets.symmetric(
          vertical: 3/scale, horizontal: 15/scale),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kToolbarHeight*0.3),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColor.blue10,
              blurRadius: 5,
            )
          ]),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.redValidator;
          } else if (value.length < 5) {
            return widget.redValidator;
          } else if (widget.prefixText == "+998 " && value.length != 12) {
            return widget.redValidator;
          }
          return null;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength),
          widget.prefixText == "+998 " ? maskFormatter : maskFormatter1
        ],
        controller: widget.controller,
        onTap: () {},
        cursorColor: AppColor.blue100,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          labelStyle:  TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: 15/scale,
            // height: 1.2,
            color: AppColor.blue100,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.blue100,
            ),
          ),
          suffixIcon: Container(
              // padding: const EdgeInsets.all(2),
              child: widget.Icon),
        ),
      ),
    );
  }
}
