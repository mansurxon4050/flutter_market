import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/widget/text_widget.dart';

import '../../color/color.dart';
import '../../widget/app_bar/person_app_bar.dart';

class PersonSecurityScreen extends StatefulWidget {
  const PersonSecurityScreen(
      {Key? key,
      required this.userName,
      required this.id,
      required this.phoneNumber})
      : super(key: key);

  final String userName, phoneNumber;
  final int id;

  @override
  State<PersonSecurityScreen> createState() => _PersonSecurityScreenState();
}

class _PersonSecurityScreenState extends State<PersonSecurityScreen> {
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: translate('person_info'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    Container(
                      height: kToolbarHeight * 1.5,
                      width: kToolbarHeight * 1.5,
                      margin: const EdgeInsets.only(
                          top: kToolbarHeight * 0.4,
                          bottom: kToolbarHeight * 0.5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(kToolbarHeight),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kToolbarHeight),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://www.planetware.com/wpimages/2020/02/france-in-pictures-beautiful-places-to-photograph-eiffel-tower.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          buildPersonInfoWidget(
            widget.id.toString(),
            Icons.person_outline,
          ),
          buildPersonInfoWidget(
            widget.userName,
            Icons.person,
          ),
          buildPersonInfoWidget(
            widget.phoneNumber,
            Icons.phone,
          ),
        ],
      ),
    );
  }

  buildPersonInfoWidget(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kToolbarHeight * 0.3, vertical: kToolbarHeight * 0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kToolbarHeight * 0.3, vertical: kToolbarHeight * 0.4),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(kToolbarHeight * 0.4),
            boxShadow: const [
              BoxShadow(
                color: AppColor.blue100,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextWidgetFade(
                  text: text,
                  textSize: kToolbarHeight * 0.28,
                  fontWeight: FontWeight.w500),
            ),
            Icon(
              icon,
              color: AppColor.blue100,
              size: kToolbarHeight * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
