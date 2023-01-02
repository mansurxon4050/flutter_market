// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/color/color.dart';
import 'package:market/model/http_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/button/submit_button.dart';
import '../../widget/dialog/center_dialog.dart';

class PasswordUpdateScreen extends StatefulWidget {
  const PasswordUpdateScreen({Key? key}) : super(key: key);

  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  String password = '';
  Color blue = AppColor.blue100;
  Repository repository = Repository();

  @override
  void initState() {
    getPassword(0);
    super.initState();
  }

  getPassword(int s) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (s == 0) {
      password = preferences.getString('password')!;
    } else {
      preferences.setString('password', newPassword.text);
      password = newPassword.text;
      newPassword.text = '';
      oldPassword.text = '';
      confirmPassword.text = '';

    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {},
            title: translate('password_change'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: blue,
                        blurRadius: 5,
                      )
                    ]),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == password) {
                      return null;
                    }
                    return translate('please_enter_password');
                  },
                  controller: oldPassword,
                  obscureText: !_passwordVisible,
                  cursorColor: blue,
                  decoration: InputDecoration(
                    labelText: translate('input_password'),
                    labelStyle: TextStyle(
                      color: blue,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: blue,
                        blurRadius: 5,
                      )
                    ]),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isNotEmpty && value.length > 5) {
                      return null;
                    }
                    return translate('enter_new_Password');
                  },
                  controller: newPassword,
                  onTap: () {},
                  obscureText: !_newPasswordVisible,
                  cursorColor: blue,
                  decoration: InputDecoration(
                    // hintText: widget.hint,
                    labelText: translate('please_enter_new_Password'),
                    labelStyle: TextStyle(
                      color: blue,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: blue,
                        blurRadius: 5,
                      )
                    ]),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        value.length > 5 &&
                        value == newPassword.text) {
                      return null;
                    }
                    return translate('please_enter_new_Password_confirm');
                  },
                  controller: confirmPassword,
                  onTap: () {},
                  obscureText: !_confirmPasswordVisible,
                  cursorColor: blue,
                  decoration: InputDecoration(
                    // hintText: widget.hint,
                    labelText: translate('please_enter_new_Password_confirm'),
                    labelStyle: TextStyle(
                      color: blue,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              SubmitButton(
                buttonName: translate('save'),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    HttpResult response = await repository.updatePassword(
                        password, newPassword.text);
                    if (response.isSuccess) {
                      getPassword(1);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(translate('save_success')),
                          backgroundColor: AppColor.blue,
                        ),
                      );
                    } else {
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
