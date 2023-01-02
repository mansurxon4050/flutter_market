import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/color/color.dart';
import 'package:market/widget/text_widget.dart';

class PersonButtonItem extends StatelessWidget {
  final Icon icon;
  final String buttonName;
  final Function() onTap;

  const PersonButtonItem(
      {Key? key,
      required this.icon,
      required this.buttonName,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: AppColor.blue1,
          blurRadius: 5,
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(10/scales)),
      margin:  EdgeInsets.symmetric(horizontal:10/scales),
      padding:  EdgeInsets.symmetric(vertical: 6/scales, horizontal: 6/scales),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kToolbarHeight*0.15, horizontal: kToolbarHeight*0.15),
                child: TextWidgetFade(
                  textSize: 16/scale,
                  fontWeight: FontWeight.w500,
                  text: buttonName,
                )),
            const Spacer(),
            Icon(
              Icons.navigate_next,
              size: kToolbarHeight*0.45,
              color: AppColor.blue100,
            )
          ],
        ),
      ),
    );
  }
}
