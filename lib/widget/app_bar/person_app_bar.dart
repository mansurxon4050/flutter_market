import 'package:flutter/material.dart';
import 'package:market/color/color.dart';

class CustomAppBarWidget extends StatelessWidget {
  final String title;
  final bool iconCheck;
  final IconButton icon;
  final Function onTap;

  const CustomAppBarWidget({Key? key,
    required this.title,
    required this.icon,
    required this.iconCheck, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    return AppBar(
      backgroundColor:AppColor.blue,
      elevation: 1,
      title: Text(
        title,
        style:  TextStyle(color: Colors.white, fontSize: 21/scale,fontWeight: FontWeight.w500,letterSpacing: 1),
      ),
      actions: [
        if(iconCheck==true)
        icon,
      ],
      leading: GestureDetector(
        onTap: () =>onTap(),
          child:const Icon(Icons.arrow_back,color: Colors.white,)
      ),
    );
  }
}
