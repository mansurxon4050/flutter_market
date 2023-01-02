// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/color/color.dart';
import 'package:market/database/database_helper.dart';
import 'package:market/model/http_result.dart';
import 'package:market/screen/category/main_category.dart';
import 'package:market/screen/home/home_screen.dart';
import 'package:market/screen/main/app_bar/shop_screen.dart';
import 'package:market/screen/person/person_screen.dart';
import 'package:market/screen/register/login.dart';
import 'package:market/screen/search/search_screen.dart';
import 'package:market/screen/setting/setting_screen.dart';
import 'package:market/service/local_notification_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/person/history_bloc.dart';
import '../../utils/language_performers.dart';
import '../../utils/utils.dart';
import '../../widget/dialog/center_dialog.dart';
import '../person/ship/ship_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.roleId}) : super(key: key);
  final String roleId;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int number = 0;
  List<String> choices = [translate('share'), translate('logout')];
  Repository repository = Repository();
  late final LocalNotificationService service;
  late var timer;
  int page=0;
  final List<Widget> _tabs = List.unmodifiable([
    const HomeScreen(),
    const CategoryScreen(),
    const PersonScreen(),
    const SettingScreen(),
  ]);

  @override
  void initState() {
    _setLanguage();
    if(widget.roleId!="user"){
      service = LocalNotificationService();
      service.intialize();
      listenToNotification();
      getHistoryData(page);
    }
    countProducts();
    super.initState();
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShipScreen(),
          ));
    }
  }

  void getHistoryData(int page) async {
    await historyProductBloc.allHistories(page,widget.roleId);
    page++;
    setState(() {});
    Timer(const Duration(minutes: 1),() {
      getHistoryData(0);
    },);
  }

  @override
  Widget build(BuildContext context) {
  final scale=MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            size: kToolbarHeight * 0.5,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const SearchScreen();
              },
            ));
          },
        ),
        actions: [
          _selectedIndex == 3
              ? PopupMenuButton(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice,style: TextStyle(fontSize: 15/scale),),
                      );
                    }).toList();
                  })
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const ShopScreen();
                      })));
                    },
                    child: Badge(
                      badgeContent: Text(
                        number.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColor.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
        ],
        elevation: 0,
        title: Text(
          translate('app_name'),
          style:  TextStyle(
              fontSize: 22/scale,
              color: AppColor.white,
              letterSpacing: 1,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: AppColor.blue,
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          countProducts();
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 1,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.blue100,
        unselectedItemColor: AppColor.blue1,
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: translate('bottomBar.home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: translate('bottomBar.market'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: translate('bottomBar.person'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: translate('bottomBar.setting'),
          ),
        ],
      ),
    );
  }

  Future<void> _setLanguage() async {
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(
        Locale(
          LanguagePerformers.getLanguage(),
        ),
      );
    });
  }

  void countProducts() async {
    int? count = await Databasehelper.instance.getCount();
    setState(() {
      number = count!;
    });
    if(_selectedIndex==0){
      timer =   Timer(const Duration(seconds: 2),() {
        countProducts();
      },);
    }
  }

  /// menu item click
  void choiceAction(String choice) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (choice == translate('share')) {
      Share.share("Market"
          "\n \n Supermarket ");
    } else {
      HttpResult response = await repository.logOut();
      if (response.isSuccess) {
        Databasehelper.instance.clear();
        preferences.clear();
        setState(() {});
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
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
}
