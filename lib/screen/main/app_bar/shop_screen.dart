import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/color/color.dart';
import 'package:market/database/database_helper.dart';
import 'package:market/model/database_model/add_cart_database_model.dart';
import 'package:market/noti.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/image_load/network_image.dart';

import '../../../api/repository.dart';
import '../../../bloc/home_star_bloc/star_product_bloc.dart';
import '../../../widget/app_bar/person_app_bar.dart';
import '../../../widget/text_widget.dart';
import 'dostavka.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int totalPrice = 0;
  Repository repository = Repository();

  @override
  void initState() {
    calcTotal();
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  void calcTotal() async {
    var totalSum = (await Databasehelper.instance.getTotal())[0]["TOTAL"];
    totalSum ??= 0;
    setState(() {
      totalPrice = totalSum;
    });
  }

  TextEditingController controller = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    final scales = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () async {
              Navigator.pop(context);
              await starProductBloc.allStarProducts(1);
            },
            title: translate('my_products'),
            iconCheck: true,
            icon: IconButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(translate('deleteAll')),
                      actions: [
                        CupertinoDialogAction(
                            onPressed: () async {
                              setState(() {
                                Databasehelper.instance.clear();
                              });
                              calcTotal();
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(
                              translate('yes'),
                              style: const TextStyle(
                                  color: AppColor.blue100,
                                  fontWeight: FontWeight.w500),
                            )),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            translate('cancel'),
                            style: const TextStyle(
                                color: AppColor.blue100,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              color: Colors.white,
            )),
      ),
      body: Center(
        child: FutureBuilder<List<Grocery>>(
          future: Databasehelper.instance.getGrocery(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(translate('please_wait')),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text(translate('product_no')),
                  )
                : ListView(
                    children: snapshot.data!.map((grocery) {
                      return Container(
                        height: kToolbarHeight * 1.5,
                        margin: const EdgeInsets.all(kToolbarHeight * 0.1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(kToolbarHeight * 0.4),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColor.blue100,
                                blurRadius: 2,
                              )
                            ]),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: kToolbarHeight * 0.1,
                            ),
                            CustomNetworkImage(
                                imageUrl: grocery.image!,
                                height: 30/scales,
                                weight: 30/scales
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        TextWidgetFade(
                                          text: grocery.name!,
                                          fontWeight: FontWeight.w600,
                                          textSize: 16/scale,
                                        ),
                                        const Spacer(),
                                        buildCountWidget(grocery, true),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            ' '
                                            '${grocery.count!}${grocery.type}'
                                            ' ',
                                            style:  TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16/scale,
                                                color: Colors.black),
                                          ),
                                        ),
                                        buildCountWidget(grocery, false),
                                        const Spacer(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidgetFade(
                                              text: NumberType.numberPrice(
                                                  grocery.price!.toString()),
                                              textSize: 15/scale,
                                              fontWeight: FontWeight.w500),
                                          const Spacer(),
                                          TextWidgetFade(
                                              text: NumberType.numberPrice(
                                                  grocery.allPrice!.toString()),
                                              textSize: 15/scale,
                                              fontWeight: FontWeight.w500),
                                          const Spacer(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: AppColor.blue100,
                              onTap: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(translate('delete')),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () async {
                                              setState(() {
                                                totalPrice = totalPrice -
                                                    grocery.allPrice!;
                                                Databasehelper.instance
                                                    .remove(grocery.id!);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              translate('yes'),
                                              style: const TextStyle(
                                                  color: AppColor.blue100,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            translate('no'),
                                            style: const TextStyle(
                                                color: AppColor.blue100,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                      // content: Text("Saved successfully"),
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    right: kToolbarHeight * 0.1),
                                child: Icon(
                                  Icons.delete,
                                  color: AppColor.blue100,
                                  size: kToolbarHeight * 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70/scales,
        padding: const EdgeInsets.symmetric(
            horizontal: kToolbarHeight * 0.4, vertical: kToolbarHeight * 0.35),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.blue100,
                blurRadius: 3,
              )
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kToolbarHeight * 0.45),
                topRight: Radius.circular(kToolbarHeight * 0.45))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate('total_amount'),
                  style:  TextStyle(
                    wordSpacing: 1,
                    fontSize: 19/scale,
                    color: AppColor.blue100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  NumberType.numberPrice(totalPrice.toString()),
                  style:  TextStyle(
                    wordSpacing: 1,
                    fontSize: 19/scale,
                    color: AppColor.blue100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                if (totalPrice > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dostavka(
                          totalPrice: totalPrice,
                        ),
                      ));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 20/scales,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.blue100,
                  borderRadius: BorderRadius.circular(kToolbarHeight * 0.4),
                ),
                child: Text(
                  translate('enter_ship_address'),
                  style: TextStyle(
                    fontSize: 17/scale,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildCountWidget(Grocery grocery, bool check) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.blue100.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ]),
      child: InkWell(
        onTap: () async {
          int count, price, allPrice;
          count = grocery.count!;
          price = grocery.price!;
          if (check) {
            count++;
          } else if (check == false && count > 1) {
            count--;
          }
          allPrice = price * count;
          await Databasehelper.instance.update(Grocery(
            id: grocery.id,
            name: grocery.name,
            type: grocery.type,
            productId: grocery.productId,
            price: grocery.price,
            info: grocery.info,
            category: grocery.category,
            image: grocery.image,
            allPrice: allPrice,
            count: count,
          ));
          calcTotal();
          setState(() {});
        },
        child: Icon(
          check ? CupertinoIcons.add : CupertinoIcons.minus,
          size: 10/MediaQuery.of(context).size.aspectRatio,
          color: Colors.black,
        ),
      ),
    );
  }
}
