import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/color/color.dart';
import 'package:market/screen/admin/admin_panel.dart';
import 'package:market/screen/setting/language_screen.dart';
import 'package:market/screen/setting/person_security_screen.dart';
import 'package:market/widget/loading/loading_widget.dart';
import 'package:market/widget/person/person_button_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/button/notification_button_setting.dart';
import 'password_update_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userName = '', phoneNumber = '', roleId = 'user';
  int id = 0;
  bool check = false;
  bool dataCheck = true;

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final scales=MediaQuery.of(context).size.aspectRatio;
    final scale=MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: dataCheck
          ? LoadingWidget(isLoading: dataCheck)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight * 0.4),
                  child: PersonButtonItem(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PersonSecurityScreen(
                              userName: userName,
                              id: id,
                              phoneNumber: phoneNumber);
                        },
                      ));
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 28,
                      color: AppColor.blue100,
                    ),
                    buttonName: translate('person_info'),
                  ),
                ),
                SizedBox(
                  height: 8/scales,
                ),
                PersonButtonItem(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const PasswordUpdateScreen();
                      },
                    ));
                  },
                  icon: const Icon(
                    Icons.vpn_key_outlined,
                    size: kToolbarHeight * 0.5,
                    color: AppColor.blue100,
                  ),
                  buttonName: translate('password_change'),
                ),
                SizedBox(
                  height: 8/scales,
                ),
                PersonButtonItem(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const LanguageScreen();
                      },
                    ));
                  },
                  icon: const Icon(
                    Icons.language,
                    size: kToolbarHeight * 0.5,
                    color: AppColor.blue100,
                  ),
                  buttonName: translate('language_change'),
                ),
                SizedBox(
                  height: 8/scales,
                ),
                NotificationButton(
                  icon:  Icon(
                    Icons.notifications,
                    size: 30/scale,
                    color: AppColor.blue100,
                  ),
                  buttonName: translate('notification'),
                ),
                SizedBox(
                  height: 8/scales,
                ),
                Visibility(
                  visible: check,
                  child: PersonButtonItem(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return  AdminScreen(roleId:roleId);
                        },
                      ));
                    },
                    icon: const Icon(
                      Icons.admin_panel_settings,
                      size: kToolbarHeight * 0.5,
                      color: AppColor.blue100,
                    ),
                    buttonName: translate('admin.admin'),
                  ),
                ),
              ],
            ),
    );
  }

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userName = preferences.getString('userName')!;
    id = preferences.getInt('userId')!;
    phoneNumber = preferences.getString('phoneNumber')!;
    roleId = preferences.getString('roleId')!;
    if (roleId != 'user') {
      check = true;
    }
    dataCheck=false;
    setState(() {});
  }
}
