import 'package:flutter/material.dart';
import 'package:market/color/color.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.buttonName,
    required this.onTap,
    this.loading = false,
  }) : super(key: key);

  final String buttonName;
  final Function() onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.blue,
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : TextButton(
                  onPressed: onTap,
                  child: Text(
                    buttonName,
                    style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}
