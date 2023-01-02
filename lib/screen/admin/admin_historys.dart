// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:market/api/repository.dart';
import 'package:market/model/http_result.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/button/submit_button.dart';
import 'package:market/widget/loading/loading_widget.dart';

import '../../color/color.dart';
import '../../utils/utils.dart';
import '../../widget/dialog/center_dialog.dart';
import '../../widget/text_widget.dart';

class AdminHistoriesScreen extends StatefulWidget {
  const AdminHistoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminHistoriesScreen> createState() => _AdminHistoriesScreenState();
}

class _AdminHistoriesScreenState extends State<AdminHistoriesScreen> {
  Color color = AppColor.blue100;
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Repository repository = Repository();
  int dayPrice =0;
  int monthPrice = 0;
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Savdo"),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
            onPressed: () async {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                        translate('delete')
                    ),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () async {
                            setState(() {
                              wait=true;
                            });
                            HttpResult response=await repository.deleteHistoryDay();
                            print(response.result);
                            if(response.isSuccess){
                              setState(() {
                                wait=false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text("Ochirildi !",
                                      style: TextStyle(
                                          fontSize: kToolbarHeight*0.28,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                            Navigator.pop(context);
                          },
                          child:  Text(
                            translate('yes'),
                            style: const TextStyle(
                                color: AppColor.blue100,
                                fontWeight:
                                FontWeight.w500),
                          )),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:  Text(
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
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.blue100,
                        blurRadius: 4,
                      )
                    ]),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidgetFade(
                              text:
                                  'kunlik savdo : ${NumberType.numberPrice(dayPrice.toString())}',
                              textSize: kToolbarHeight * 0.3,
                              fontWeight: FontWeight.w500),
                          TextWidgetFade(
                              text:
                                  'Oylik savdo : ${NumberType.numberPrice(monthPrice.toString())}',
                              textSize: kToolbarHeight * 0.30,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: color,
                        blurRadius: 5,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      onChanged: (value) {},
                      validator: (value) {
                        if (value != '') {
                          return null;
                        }
                        return 'Kunni kiriting Masalan 01,02,23';
                      },
                      controller: controller,
                      cursorColor: color,
                      decoration: InputDecoration(
                        hintText: '01',
                        labelText: 'Kun kiriting',
                        labelStyle: TextStyle(
                          color: color,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SubmitButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        wait = true;
                      });
                      var data = {
                        "day": controller.text,
                        "month":
                            DateFormat('M').format(DateTime.now()).toString(),
                      };
                      HttpResult response =
                          await repository.getDayMonthPrice(data);
                      if (response.isSuccess) {
                        setState(() {
                          dayPrice = response.result["day"];
                          monthPrice = response.result["month"];
                          wait = false;
                        });
                      }else {
                        if (response.status == -1) {
                          CenterDialog
                              .networkErrorDialog(
                              context);
                        } else {
                          CenterDialog.errorDialog(
                            context,
                            Utils.serverErrorText(
                                response),
                          );
                        }
                      }
                    }
                  },
                  buttonName: "Summani olish")
            ],
          ),
          LoadingWidget(isLoading: wait),
        ],
      ),
    );
  }
}
