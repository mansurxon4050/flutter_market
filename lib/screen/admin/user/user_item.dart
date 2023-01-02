// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/model/admin/users_model.dart';
import 'package:market/model/http_result.dart';
import 'package:market/widget/button/submit_button.dart';
import 'package:market/widget/loading/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/admin/admin_users.dart';
import '../../../color/color.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/person/person_button_item.dart';

class AdminUserItem extends StatefulWidget {
  const AdminUserItem({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  State<AdminUserItem> createState() => _AdminUserItemState();
}

class _AdminUserItemState extends State<AdminUserItem> {
  Repository repository = Repository();
  bool normalUser = true;
  bool wait = false;
  late String userRole;
  late String myRole;
  Color color = AppColor.blue100;

  @override
  void initState() {
    getMe();
    super.initState();
  }

  getMe() {
    if (widget.userData.roleId == 'user') {
      userRole = 'normalUser';
    } else if (widget.userData.roleId == 'normalUser') {
      userRole = 'admin';
    } else {
      userRole = 'user';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('admin.users')),
        backgroundColor: AppColor.blue,
      ),
      body: wait
          ? LoadingWidget(isLoading: wait)
          : Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                PersonButtonItem(
                  onTap: () {},
                  icon: Icon(
                    Icons.verified_user,
                    color: color,
                    size: kToolbarHeight * 0.4,
                  ),
                  buttonName: widget.userData.id.toString(),
                ),
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                PersonButtonItem(
                  onTap: () {},
                  icon: Icon(
                    Icons.person_outline,
                    color: color,
                    size: kToolbarHeight * 0.4,
                  ),
                  buttonName: widget.userData.name,
                ),
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                PersonButtonItem(
                  onTap: () {},
                  icon: Icon(
                    Icons.phone,
                    color: color,
                    size: kToolbarHeight * 0.4,
                  ),
                  buttonName: widget.userData.phoneNumber,
                ),
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                PersonButtonItem(
                  onTap: () {},
                  icon: Icon(
                    Icons.timer_outlined,
                    color: color,
                    size: kToolbarHeight * 0.4,
                  ),
                  buttonName: widget.userData.createdAt,
                ),
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                PersonButtonItem(
                  onTap: () {},
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: color,
                    size: kToolbarHeight * 0.4,
                  ),
                  buttonName: widget.userData.roleId,
                ),
                const Spacer(),
                SubmitButton(
                    onTap: () async {
                      resultRole(userRole);
                    },
                    buttonName: '$userRole qilish'),
              ],
            ),
    );
  }

  resultRole(String role) async {
    setState(() {
      wait = true;
    });
    HttpResult response = await repository.userUpdate(widget.userData.id, role);
    if (response.isSuccess) {
      setState(() {
        wait = false;
      });
      await allUsersBloc.allUsersFunction(1);
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Xabar",
              style: TextStyle(color: AppColor.blue100),
            ),
            content: const Text(
              'Muvaffaqiyatli omalga oshirildi !',
              style: TextStyle(fontSize: kToolbarHeight * 0.25),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
    } else {
      setState(() {
        wait = false;
      });
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context);
      } else {
        CenterDialog.errorDialog(
          context,
          Utils.serverErrorText(response),
        );
      }
    }
  }
}
