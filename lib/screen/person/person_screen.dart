import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/color/color.dart';
import 'package:market/model/http_result.dart';
import 'package:market/screen/person/admin_chat.dart';
import 'package:market/screen/person/favorite_screen.dart';
import 'package:market/screen/person/news_screen.dart';
import 'package:market/screen/person/ship/ship_screen.dart';
import 'package:market/screen/person/shopping_history_screen.dart';
import 'package:market/widget/loading/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register/login_model.dart';
import '../../widget/person/person_button_item.dart';
import 'chegirma_product.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Repository repository = Repository();
  int id = 0;
  bool wait = true;
  String userName = '', roleId = 'user';
  Color color = AppColor.blue100;

  @override
  void initState() {
    getId();
    super.initState();
  }

  void getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    HttpResult response = await repository.getUserInfo();
    if (response.isSuccess) {
      User user = User.fromJson(response.result);
      preferences.setInt('userId', user.id);
      preferences.setString('userName', user.name);
      preferences.setString('roleId', user.roleId);
      id = user.id;
      userName = user.name;
      roleId = user.roleId;
    } else {
      id = preferences.getInt('userId')!;
      userName = preferences.getString('userName')!;
      roleId = preferences.getString('roleId')!;
    }
    setState(() {
      wait = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      body: wait
          ? LoadingWidget(isLoading: wait)
          : SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kToolbarHeight * 0.3),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.blue1,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(20)),
                      margin:  EdgeInsets.symmetric(
                          horizontal: 4/scales),
                      padding:  EdgeInsets.symmetric(
                          vertical: 4/scales,
                          horizontal: 4/scales),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://www.planetware.com/wpimages/2020/02/france-in-pictures-beautiful-places-to-photograph-eiffel-tower.jpg",
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.black,
                                ),
                              ),
                              height: 35/scales,
                              width: 35/scales,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(kToolbarHeight * 0.15),
                                child: Text(
                                  userName,
                                  style:  TextStyle(
                                      fontSize:16/scale,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(kToolbarHeight * 0.08),
                                child: Text(
                                  '${translate('user_id')}$id',
                                  style:  TextStyle(
                                    fontSize: 14/scale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2/scales,
                  ),
                  PersonButtonItem(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ShoppingHistoryScreen(
                            id: id,
                          );
                        },
                      ));
                    },
                    buttonName: translate('history_sold'),
                    icon: Icon(
                      Icons.history_edu,
                      size: 15/scales,
                      color: color,
                    ),
                  ),
                  SizedBox(
                    height: 8/scales,
                  ),
                  PersonButtonItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const FavoriteScreen();
                          },
                        ));
                      },
                      buttonName: translate('favorite'),
                      icon: Icon(
                        Icons.favorite_border,
                        color: color,
                        size: kToolbarHeight * 0.5,
                      )),
                  SizedBox(
                    height: 8/scales,
                  ),
                  PersonButtonItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const NewsScreen();
                          },
                        ));
                      },
                      buttonName: translate('news'),
                      icon: Icon(
                        Icons.sticky_note_2_rounded,
                        color: color,
                        size: kToolbarHeight * 0.5,
                      )),
                  SizedBox(
                    height: 8/scales,
                  ),
                  PersonButtonItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const ChegirmaProductScreen();
                          },
                        ));
                      },
                      buttonName: translate('discount_product'),
                      icon: Icon(
                        Icons.shopping_cart_checkout,
                        size: kToolbarHeight * 0.5,
                        color: color,
                      )),
                  SizedBox(
                    height: 8/scales,
                  ),
                  PersonButtonItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const AdminChat();
                          },
                        ));
                      },
                      buttonName: translate('admin_chat'),
                      icon: Icon(
                        Icons.headset_mic,
                        size: kToolbarHeight * 0.5,
                        color: color,
                      )),
                  SizedBox(
                    height: 8/scales,
                  ),
                  Visibility(
                    visible: roleId!='user',
                    child: PersonButtonItem(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ShipScreen();
                            },
                          ));
                        },
                        buttonName: 'Yetkazib berish',
                        icon: Icon(
                          Icons.local_shipping,
                          size: kToolbarHeight * 0.5,
                          color: color,
                        )),
                  ),
                ],
              ),
          ),
    );
  }
}
