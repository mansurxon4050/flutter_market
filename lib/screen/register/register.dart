// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/repository.dart';
import '../../color/color.dart';
import '../../model/http_result.dart';
import '../../model/register/register_model.dart';
import '../../utils/utils.dart';
import '../../widget/dialog/center_dialog.dart';
import '../../widget/register_widget/background-image.dart';
import '../../widget/register_widget/password-input.dart';
import '../../widget/register_widget/rounded-button.dart';
import '../../widget/register_widget/text-field-input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool circle = false;
  Repository repository = Repository();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();
  bool submitValid = true;
  @override
  void initState() {
    _phoneNumberController.text='+998';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(
          image: 'assets/images/login.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: submitValid
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: CircleAvatar(
                                  radius: size.width * 0.14,
                                  backgroundColor:
                                      Colors.grey[400]!.withOpacity(
                                    0.4,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.user,
                                    color: kWhite,
                                    size: size.width * 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.08,
                            left: size.width * 0.56,
                            child: Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                color: kBlue,
                                shape: BoxShape.circle,
                                border: Border.all(color: kWhite, width: 2),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.arrowUp,
                                color: kWhite,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Column(
                        children: [
                          TextInputField(
                            controller: _fullNameController,
                            icon: FontAwesomeIcons.user,
                            hint: 'UserName',
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                          ),
                          TextInputField(
                            controller: _phoneNumberController,
                            icon: FontAwesomeIcons.phoneAlt,
                            hint: 'Phone Number',
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                          ),
                          PasswordInput(
                            controller: _passwordController,
                            icon: FontAwesomeIcons.lock,
                            hint: 'Password',
                            inputAction: TextInputAction.next,
                          ),
                          PasswordInput(
                            controller: _confirmPasswordController,
                            icon: FontAwesomeIcons.lock,
                            hint: 'Confirm Password',
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          RoundedButton(
                            loading: circle,
                            buttonName: 'Register',
                            onTap: () async {
                              circle = true;
                              setState(() {});
                              HttpResult response = await repository.register(
                                _fullNameController.text,
                                _phoneNumberController.text,
                                _passwordController.text,
                                _confirmPasswordController.text,
                              );

                              if (response.isSuccess) {
                                RegisterModel data = RegisterModel.fromJson(
                                  response.result,
                                );
                                if (data.token != "") {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("login_main",true);
                                  prefs.setString("token", data.token);
                                  prefs.setString("userName", data.user.name);
                                  prefs.setInt("userId", data.user.id);
                                  prefs.setString("roleId", "user");
                                  prefs.setString("phoneNumber", data.user.phoneNumber);
                                  prefs.setString("password", _passwordController.text);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return  MainScreen(roleId: prefs.getString("roleId")??"user",);
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
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: kBodyText,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text(
                                  'Login',
                                  style: kBodyText.copyWith(
                                      color: kBlue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          Container(
                            width: size.width * 0.8,
                            child: const Text(
                              'A code has been sent to your email. Enter the code',
                              style: kBodyText,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller1,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller2,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller3,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller4,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller5,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: TextField(
                                    controller: _controller6,

                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    style: const TextStyle(
                                        color: kWhite, fontSize: 25),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhite, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2)),
                                    ),
                                    //style: Theme.of(context).textTheme.headline6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RoundedButton(
                            buttonName: 'Send',
                            onTap: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
        )
      ],
    );
  }
}
// late EmailAuth emailAuth;
// late String _otpcontroller;
//
// @override
// void initState() {
//   super.initState();
//   // Initialize the package
//   emailAuth = EmailAuth(
//     sessionName: "SuperMarket",
//   );
// }
//
// void verify() async {
//   print(_emailController.value.text);
//   print(_otpcontroller);
//   bool data = emailAuth.validateOtp(
//       recipientMail: _emailController.value.text, userOtp: _otpcontroller);
//   print(data);
//   if (data) {
//     // Navigator.popUntil(context, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           return const MainScreen();
//         },
//       ),
//     );
//   }
// }
//
// void sendOtp() async {
//   bool result = await emailAuth.sendOtp(
//       recipientMail: _emailController.value.text, otpLength: 5);
//   if (result) {
//     setState(() {
//       submitValid = false;
//     });
//     print('SendOtp');
//   }
// }

// RoundedButton(
// buttonName: 'Send',
// onTap: () {
// _otpcontroller = _controller1.value.text +
// _controller2.value.text +
// _controller3.value.text +
// _controller4.value.text +
// _controller5.value.text +
// _controller6.value.text;
// setState(() {});
// verify();
// },
// )
