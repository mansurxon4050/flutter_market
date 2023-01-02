import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/color/color.dart';

class CenterDialog {
  static errorDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:  Text(translate('error')),
          content: Text(
            text,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColor.dark33,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static messageDialog(BuildContext context, String text, Function() onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:  Text(translate('message'),style: const TextStyle(color: AppColor.blue100),),
          content: Text(
            text,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: AppColor.fontFamilyProxima,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColor.dark33,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static selectDialog(
      BuildContext context, String text, Function(bool value) onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:  Text(
            translate('message'),
            style: const TextStyle(
              fontFamily: AppColor.fontFamilyProduct,
            ),
          ),
          content: Text(
            text,
            style: const TextStyle(
              fontFamily: AppColor.fontFamilyProduct,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                onTap(true);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: AppColor.fontFamilyProxima,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColor.dark33,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(false);
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    "Yoq",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: AppColor.fontFamilyProxima,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColor.dark33,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static networkErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:  Text(
            translate('internet_error_network_title'),
            style: const TextStyle(
              fontFamily: AppColor.fontFamilyProduct,
            ),
          ),
          content:  Text(
            translate('internet_error'),
            style: const TextStyle(
              fontFamily: AppColor.fontFamilyProduct,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColor.blue100,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
