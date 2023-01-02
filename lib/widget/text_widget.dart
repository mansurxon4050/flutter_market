import 'package:flutter/material.dart';

class TextWidgetFade extends StatelessWidget {
  const TextWidgetFade({Key? key, required this.text, required this.textSize, required this.fontWeight}) : super(key: key);
  final String text;
  final double textSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
      textAlign: TextAlign.center,
      style:  TextStyle(
          fontSize: textSize,
          color: Colors.black,
          fontWeight: fontWeight
      ),
    );
  }
}
