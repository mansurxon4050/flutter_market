import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/screen/admin/max_price/admin_max_month_price.dart';
import 'package:market/screen/admin/product/products_screen.dart';
import 'package:market/screen/admin/user/users_screen.dart';

import '../../color/color.dart';
import '../../widget/person/person_button_item.dart';
import 'admin_historys.dart';
import 'news/admin_news_screen.dart';
import 'banner/banners_screen.dart';
import 'category/categories_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key, required this.roleId}) : super(key: key);
  final String roleId;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Admin '),
        backgroundColor: AppColor.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8/scales,
            ),
            Visibility(
              visible: widget.roleId == "admin",
              child: PersonButtonItem(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const UsersScreen();
                    },
                  ));
                },
                icon:  Icon(
                  Icons.person_outline,
                  size: 15/scales,
                  color: AppColor.blue100,
                ),
                buttonName: translate('admin.users'),
              ),
            ),
            SizedBox(
              height: 8/scales,
            ),
            PersonButtonItem(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const ProductsScreen();
                  },
                ));
              },
              icon:  Icon(
                Icons.production_quantity_limits,
                size: 15/scales,
                color: AppColor.blue100,
              ),
              buttonName: translate('admin.products'),
            ),
            SizedBox(
              height: 8/scales,
            ),
            PersonButtonItem(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const AdminCategoriesScreen();
                  },
                ));
              },
              icon:  Icon(
                Icons.category_sharp,
                size: 15/scales,
                color: AppColor.blue100,
              ),
              buttonName: translate('admin.categories'),
            ),
            SizedBox(
              height: 8/scales,
            ),
            Visibility(
              visible: widget.roleId == "admin",
              child: PersonButtonItem(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AdminHistoriesScreen();
                    },
                  ));
                },
                icon:  Icon(
                  Icons.history_edu,
                  size: 15/scales,
                  color: AppColor.blue100,
                ),
                buttonName: translate('admin.histories'),
              ),
            ),
            SizedBox(
              height: 8/scales,
            ),
            Visibility(
              visible: widget.roleId == "admin",
              child: PersonButtonItem(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const BannersScreen();
                    },
                  ));
                },
                icon:  Icon(
                  Icons.slideshow,
                  size: 15/scales,
                  color: AppColor.blue100,
                ),
                buttonName: translate('admin.banners'),
              ),
            ),
            SizedBox(
              height: 8/scales,
            ),
            Visibility(
              visible: widget.roleId == "admin",
              child: PersonButtonItem(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AdminNewsScreen();
                    },
                  ));
                },
                icon:  Icon(
                  Icons.newspaper,
                  size: 15/scales,
                  color: AppColor.blue100,
                ),
                buttonName: translate('admin.news'),
              ),
            ),
            SizedBox(
              height: 8/scales,
            ),
            Visibility(
              visible: widget.roleId == "admin",
              child: PersonButtonItem(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AdminMaxPrice();
                    },
                  ));
                },
                icon:  Icon(
                  Icons.analytics_outlined,
                  size: 15/scales,
                  color: AppColor.blue100,
                ),
                buttonName: "Month Max Sum",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
