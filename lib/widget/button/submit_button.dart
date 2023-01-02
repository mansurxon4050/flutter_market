import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/color/color.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key, required this.onTap, required this.buttonName}) : super(key: key);
  final Function() onTap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    final scales = MediaQuery.of(context).size.aspectRatio;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8/scales),
        padding:  EdgeInsets.symmetric(vertical: 7/scales),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kToolbarHeight*0.4),
          color: AppColor.blue100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(
              buttonName,
              style: TextStyle(
                fontSize: 18/scale,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
