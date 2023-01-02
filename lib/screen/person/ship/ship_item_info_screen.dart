// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/api/repository.dart';
import 'package:market/color/color.dart';
import 'package:market/model/http_result.dart';
import 'package:market/model/person/history_model.dart';
import 'package:market/widget/loading/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/person/history_bloc.dart';
import '../../../utils/number_format.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/text_widget.dart';

class SHipItemInfoScreen extends StatefulWidget {
  const SHipItemInfoScreen({
    Key? key,
    required this.model,
  }) : super(key: key);
  final HistoryInfo model;

  @override
  State<SHipItemInfoScreen> createState() => _SHipItemInfoScreenState();
}

class _SHipItemInfoScreenState extends State<SHipItemInfoScreen> {
  String userName = '';
  Repository repository = Repository();
  bool wait = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userName = preferences.getString('userName')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyurtma'),
        backgroundColor: AppColor.blue,
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kToolbarHeight * 0.3),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: AppColor.blue100,
                blurRadius: 5,
              )
            ],
          ),
          margin:  EdgeInsets.symmetric(
              vertical: 4/scales,
              horizontal:4/scales),
          padding: EdgeInsets.all(2/scales),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextWidgetFade(
                    text: 'id:${widget.model.id}   ${widget.model.orderTime}',
                    textSize: 22/scale,
                    fontWeight: FontWeight.bold),
                ListView.builder(
                  primary: false,
                  itemCount: widget.model.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    List<HistoryInfoData> historyData = widget.model.data;
                    return Container(
                      margin:  EdgeInsets.only(top:4/scales),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextWidgetFade(
                                    text: historyData[index].name,
                                    textSize: 16/scale,
                                    fontWeight: FontWeight.w600),
                                TextWidgetFade(
                                    text: historyData[index].info,
                                    textSize:15/scale,
                                    fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:2/scales),
                              child: Column(
                                children: [
                                  TextWidgetFade(
                                      text: '${historyData[index].count}'
                                          ' ${historyData[index].type}',
                                      textSize: 16/scale,
                                      fontWeight: FontWeight.w600),
                                  TextWidgetFade(
                                      text: NumberType.numberPrice(
                                          historyData[index].price.toString()),
                                      textSize: 15/scale,
                                      fontWeight: FontWeight.w500),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextWidgetFade(
                              text: NumberType.numberPrice(
                                  historyData[index].allPrice.toString()),
                              textSize: 16/scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: kToolbarHeight * 0.2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextWidget(
                        'Buyurtmachini ismi : ${widget.model.userName}'),
                    buildTextWidget(
                        'Yetkazib berish manzili : ${widget.model.address}'),
                    buildTextWidget('Muljal :${widget.model.muljal}'),
                    buildTextWidget(
                        'Buyurtmachini telefon raqami : ${widget.model.addressPhoneNumber}'),
                    buildTextWidget(
                        'Buyurtmani qabul qilingan vaqt : ${widget.model.acceptedTime}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(kToolbarHeight * 0.1),
                      child: TextWidgetFade(
                        text: 'umumiy summa ',
                        textSize: 18/scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kToolbarHeight * 0.1),
                      child: TextWidgetFade(
                        text: NumberType.numberPrice(
                            widget.model.totalPrice.toString()),
                        textSize: 18/scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (widget.model.make == '') {
                      setState(() {
                        wait = true;
                      });
                      var data = {
                        "id": widget.model.id,
                        "make": userName,
                        "ready": '',
                        "driver": '',
                      };
                      buildDialog(context, data);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: TextWidgetFade(
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                              text: 'Tayyorlayman',
                            )),
                      ),
                      TextWidgetFade(
                          text: widget.model.make.isEmpty
                              ? 'hech kim'
                              : widget.model.make,
                          textSize: 14,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (widget.model.make == userName &&
                        widget.model.ready == '') {
                      setState(() {
                        wait = true;
                      });
                      var data = {
                        "id": widget.model.id,
                        "ready": DateFormat('H:mm')
                            .format(DateTime.now())
                            .toString(),
                      };
                      buildDialog(context, data);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: TextWidgetFade(
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                              text: 'Tayyor',
                            )),
                      ),
                      TextWidgetFade(
                          text: widget.model.ready.isEmpty
                              ? 'hech kim'
                              : widget.model.ready,
                          textSize: 14,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (widget.model.ready.isNotEmpty&& widget.model.driver=='') {
                      setState(() {
                        wait = true;
                      });
                      var data = {
                        "id": widget.model.id,
                        "ready": '',
                        "driver": userName,
                      };
                      buildDialog(context, data);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: TextWidgetFade(
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                              text: 'Yulda',
                            )),
                      ),
                      TextWidgetFade(
                          text: widget.model.driver.isEmpty
                              ? 'hech kim'
                              : widget.model.driver,
                          textSize: 14,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        wait ? LoadingWidget(isLoading: wait) : Container()
      ]),
    );
  }

  buildTextWidget(String text) {
    final scale=MediaQuery.of(context).textScaleFactor;
    return Text(
      text,
      style:  TextStyle(
          fontSize: 16/scale, fontWeight: FontWeight.w500),
    );
  }

  void buildDialog(BuildContext context, var data) async {
    HttpResult response =
        await repository.setDataNormalUser(widget.model.id, data);
    if (response.isSuccess) {
      setState(() {
        wait = false;
      });
      await historyProductBloc.allHistories(1,"normalUser");
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Xabar",
              style: TextStyle(color: AppColor.blue100),
            ),
            content: const Text(
              'Muvaffaqiyatli amalga oshirildi',
              style: TextStyle(fontSize: kToolbarHeight * 0.25),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.transparent,
                  child: const Center(
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: AppColor.fontFamilyProxima,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColor.dark33,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      );
    } else {
      setState(() {
        wait = false;
      });
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
