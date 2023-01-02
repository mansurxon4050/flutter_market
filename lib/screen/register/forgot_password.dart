import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_auth/email_auth.dart';

import '../../color/color.dart';
import '../../widget/register_widget/background-image.dart';
import '../../widget/register_widget/rounded-button.dart';
import '../../widget/register_widget/text-field-input.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool submitValid = false;

  final TextEditingController _phoneController = TextEditingController();


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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: const Text(
              'Forgot Password',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: Column(
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
                        'Enter your email we will send instruction to reset your password',
                        style: kBodyText,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextInputField(
                      icon: FontAwesomeIcons.envelope,
                      hint: 'Phone number',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                      controller: _phoneController,
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
// final TextEditingController _otpcontroller = TextEditingController();
//
//
// late EmailAuth emailAuth;
//
// @override
// void initState() {
//   super.initState();
//   // Initialize the package
//   emailAuth = new EmailAuth(
//     sessionName: "SuperMarket",
//   );
// }
//
//
// void verify() {
//   bool da = emailAuth.validateOtp(
//       recipientMail: _emailcontroller.value.text,
//       userOtp: _otpcontroller.value.text);
//   if (da) {
//     // Navigator.push(context, MaterialPageRoute(
//     //   builder: (context) {
//     //     return const HomeMainScreen();
//     //   },
//     // ));
//   }
// }
//
// /// a void funtion to send the OTP to the user
// /// Can also be converted into a Boolean function and render accordingly for providers
// void sendOtp() async {
//   bool result = await emailAuth.sendOtp(
//       recipientMail: _emailcontroller.value.text, otpLength: 5);
//   if (result) {
//     setState(() {
//       submitValid = true;
//     });
//   }
// }