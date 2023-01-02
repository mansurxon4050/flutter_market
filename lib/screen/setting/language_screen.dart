// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/color/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/language_performers.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/button/submit_button.dart';
import '../main/main_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int click = 1;
  String languages =LanguagePerformers.getLanguage();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: translate('language_change'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      languages = 'uz';
                      setState(() {});
                    },
                    child: containerLanguage(translate('uzbek'), 'uz',context,languages),
                  ),
                  GestureDetector(
                    onTap: () {
                      languages = 'ru';
                      setState(() {});
                    },
                    child: containerLanguage(translate('rus'), 'ru',context,languages),
                  ),
                  GestureDetector(
                    onTap: () {
                      languages = 'en';
                      setState(() {});
                    },
                    child: containerLanguage(translate('english'), 'en',context,languages),
                  ),
                ],
              ),
              !loading
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 56,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.black12,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'loading ...',
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
          const Spacer(),
          SubmitButton(
            buttonName: translate('save'),
            onTap: () async{
              var localizationDelegate = LocalizedApp.of(context).delegate;
              localizationDelegate
                  .changeLocale(Locale(languages));
              LanguagePerformers.saveLanguage(languages);
              SharedPreferences pref=await SharedPreferences.getInstance();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen( roleId: pref.getString("roleId")??"user"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
containerLanguage(String text, String tapLang,BuildContext context,String languages) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: Colors.transparent,
    child: Column(
      children: [
        Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 17,
                height: 24 / 17,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: languages == tapLang ? AppColor.blue100 : Colors.white,
                borderRadius: BorderRadius.circular(kToolbarHeight * 0.4),
                border: Border.all(
                  width: 2,
                  color: languages == tapLang ? AppColor.blue100 : Colors.black12,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: kToolbarHeight * 0.4,
              ),
            )
          ],
        ),
        const SizedBox(
          height: kToolbarHeight * 0.4,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
        )
      ],
    ),
  );
}
