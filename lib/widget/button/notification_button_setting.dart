import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/color/color.dart';

class NotificationButton extends StatefulWidget {
  final Icon icon;
  final String buttonName;

  const NotificationButton(
      {Key? key, required this.icon, required this.buttonName})
      : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool _value = true;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.icon,
          Padding(
            padding: const EdgeInsets.symmetric(vertical:  kToolbarHeight*0.17, horizontal:  kToolbarHeight*0.2),
            child: Text(
              widget.buttonName,
              style:  TextStyle(fontSize: 16/scale, fontWeight: FontWeight.w500),
            ),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: _value,
            thumbColor: CupertinoColors.white,
            trackColor: AppColor.blue100.withOpacity(0.5),
            activeColor: AppColor.blue100.withOpacity(1),
            onChanged: (bool? value) {
              setState(() {
                _value = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
