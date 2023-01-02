import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/screen/main/main_screen.dart';
import 'package:market/screen/register/login.dart';
import 'package:market/utils/language_performers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language = "uz";

void main() async {
  // runApp( MyApp()  );
  WidgetsFlutterBinding.ensureInitialized();

  ///languageni init qivolindi
  await LanguagePerformers.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  /// login check
  bool open = prefs.getBool("login_main") ?? false;
  String roleId = prefs.getString("roleId") ?? "user";

  ///language yaratilmoqda
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'uz',
    supportedLocales: ['ru', 'en', 'uz'],
  );
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ],
  ).then(
    (_) => runApp(
      LocalizedApp(
        delegate,
        MyApp(open: open,roleId: roleId),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.open, required this.roleId}) : super(key: key);
  final bool open;
  final String roleId;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        localizationDelegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      locale: localizationDelegate.currentLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //platform: TargetPlatform.iOS,
      ),
      home: open ?  MainScreen(roleId: roleId,) : const LoginScreen(),
    );
  }
}
