
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:market/color/color.dart';
import 'package:market/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/repository.dart';
import '../../../database/database_helper.dart';
import '../../../model/http_result.dart';
import '../../../utils/utils.dart';
import '../../../widget/app_bar/person_app_bar.dart';
import '../../../widget/button/submit_button.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/dostavka/address_location.dart';
import '../../../widget/loading/loading_widget.dart';

class Dostavka extends StatefulWidget {
  const Dostavka({Key? key, required this.totalPrice}) : super(key: key);
  final int totalPrice;

  @override
  State<Dostavka> createState() => _DostavkaState();
}

class _DostavkaState extends State<Dostavka> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController muljal = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  Repository repository = Repository();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final scale = MediaQuery.of(context).textScaleFactor;
    final scales = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: translate('shipping_address'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: kToolbarHeight * 0.1,
                  horizontal: kToolbarHeight * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all( kToolbarHeight*0.15),
                    padding: const EdgeInsets.all(kToolbarHeight * 0.15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(kToolbarHeight * 0.2),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: AppColor.blue100, blurRadius: 2),
                        ]),
                    child:  Text(
                      translate('note_ship'),
                      style:  TextStyle(
                          fontSize: 15/scale,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: kToolbarHeight * 0.1,
                  ),
                  AddressAdd(
                    controller: name,
                    keyboardType: TextInputType.name,
                    hintText:    translate('input_name'),
                    prefixText: '',
                    label: translate('name'),
                    Icon:  Icon(Icons.person,
                        size: 14/scales, color: AppColor.blue100),
                    redValidator:    translate('input_name_error'),
                    maxLength: TextField.noMaxLength,
                  ),
                  AddressAdd(
                    controller: address,
                    keyboardType: TextInputType.name,
                    hintText:    translate('hint_address'),
                    prefixText: '',
                    label:   translate('address'),
                    Icon:  Icon(Icons.location_history,
                        size: 14/scales, color: AppColor.blue100),
                    redValidator:   translate('address_error'),
                    maxLength: TextField.noMaxLength,
                  ),
                  AddressAdd(
                    controller: muljal,
                    keyboardType: TextInputType.name,
                    hintText:   '',
                    prefixText: '',
                    label:   translate('muljal'),
                    Icon:  Icon(Icons.location_history_outlined,
                        size: 14/scales, color: AppColor.blue100),
                    redValidator:    translate('muljal_error'),
                    maxLength: TextField.noMaxLength,
                  ),
                  AddressAdd(
                    controller: phoneNumber,
                    keyboardType: TextInputType.number,
                    hintText: '',
                    prefixText: '+998 ',
                    label:    translate('phone_number'),
                    Icon:  Icon(Icons.phone,
                        size: 14/scales, color: AppColor.blue100),
                    redValidator:   translate('phone_number_error'),
                    maxLength: 12,
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:       SubmitButton(
        buttonName:   translate('cart'),
        onTap: () {
          if (_formKey.currentState!.validate()) {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title:  Text(   translate('payment_type')),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () async {
                          SharedPreferences pref =
                          await SharedPreferences.getInstance();
                          int userId = pref.getInt('userId') ?? 0;
                          var list =
                          await Databasehelper.instance.getGrocerys();
                          var data = {
                            "user_id": userId,
                            "payment_type": "money",
                            "name": name.text,
                            "total_price": widget.totalPrice,
                            "address": address.text,
                            "muljal": muljal.text,
                            "address_phone_number": '+998 ${phoneNumber.text}',
                            "long": "",
                            "lat": "",
                            "order_time": DateFormat("MMM dd, yyyy H:mm ")
                                .format(DateTime.now())
                                .toString(),
                            "accepted_time": '',
                            "data": list,
                          };
                          HttpResult response = await repository.sold(data);
                          if (response.isSuccess) {
                            Databasehelper.instance.clear();
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                duration: const Duration(seconds: 5),
                                content: Text(    translate('order_send'),
                                    style: const TextStyle(
                                        fontSize: kToolbarHeight*0.28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>  MainScreen(roleId: pref.getString("roleId")??"user",)),
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
                          // Noti.showBigTextNotification(title: 'Message title', body:"royxat", fn: flutterLocalNotificationsPlugin);
                        },
                        child:  Text(
                          translate('cash_money'),
                          style: const TextStyle(
                              color: AppColor.blue100,
                              fontWeight: FontWeight.w500),
                        )),
                    CupertinoDialogAction(
                      onPressed: () {
                       CenterDialog.messageDialog(context,    translate('card_payment_not'), () => Navigator.pop(context));

                      },
                      child:  Text(
                        translate('card'),
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
          }
        },
      ),
    );
  }
}
