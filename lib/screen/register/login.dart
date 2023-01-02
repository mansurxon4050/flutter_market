// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market/screen/main/main_screen.dart';
import 'package:market/screen/register/forgot_password.dart';
import 'package:market/screen/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/repository.dart';
import '../../color/color.dart';
import '../../model/http_result.dart';
import '../../model/register/login_model.dart';
import '../../utils/utils.dart';
import '../../widget/dialog/center_dialog.dart';
import '../../widget/register_widget/background-image.dart';
import '../../widget/register_widget/password-input.dart';
import '../../widget/register_widget/rounded-button.dart';
import '../../widget/register_widget/text-field-input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool circle = false;
  Repository repository = Repository();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String roleId="user";
  @override
  void initState() {
    checkLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(
          image: 'assets/images/login.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const Flexible(
                child: Center(
                  child: Text(
                    'SuperMarket',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    controller: _phoneNumberController,
                    icon: FontAwesomeIcons.phoneAlt,
                    hint: 'Phone number',
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    controller: _passwordController,
                    icon: FontAwesomeIcons.lock,
                    hint: 'Password',
                    inputAction: TextInputAction.done,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        )),
                    child: const Text(
                      'Forgot Password',
                      style: kBodyText,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundedButton(
                    loading: circle,
                    buttonName: 'Login',
                    onTap: () async {
                      circle = true;
                      setState(() {});
                      HttpResult response = await repository.login(
                          _phoneNumberController.text, _passwordController.text);
                      if (response.isSuccess) {
                        LoginModel data = LoginModel.fromJson(
                          response.result,
                        );
                        if (data.token != "") {
                          roleId=data.user.roleId;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("login_main",true);
                          prefs.setString("token", data.token);
                          prefs.setString("userName", data.user.name);
                          prefs.setString("password", _passwordController.text);
                          prefs.setInt("userId", data.user.id);
                          prefs.setString("roleId", "admin");
                          prefs.setString("phoneNumber", data.user.phoneNumber);
                          print('user info saqlandi !!! ');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return  MainScreen(roleId:prefs.getString("roleId")??"user");
                              },
                            ),
                          );
                        } else {
                          CenterDialog.errorDialog(
                            context,
                            Utils.serverErrorText(response),
                          );
                        }
                      } else if (response.status == -1) {
                        CenterDialog.networkErrorDialog(context);
                      } else {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                        );
                      }
                      setState(() {
                        circle = false;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                  child: const Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
  void checkLogin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('token') != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return  MainScreen(roleId: roleId,);
          },
        ),
      );
    }
  }
}
