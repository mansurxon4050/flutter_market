// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/model/person/history_model.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/app_bar/person_app_bar.dart';
import 'package:market/widget/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/repository.dart';
import '../../bloc/person/history_bloc.dart';
import '../../color/color.dart';
import '../../model/http_result.dart';
import '../../utils/utils.dart';
import '../../widget/dialog/center_dialog.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/category_shimmer.dart';
import '../../widget/shimmer/home_shimmer.dart';

class ShoppingHistoryScreen extends StatefulWidget {
  const ShoppingHistoryScreen({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<ShoppingHistoryScreen> createState() => _ShoppingHistoryScreenState();
}

class _ShoppingHistoryScreenState extends State<ShoppingHistoryScreen> {
  int page = 1;
  bool isLoading = false;
  bool delete = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  late int userId;

  @override
  void initState() {
    getHistoryData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getHistoryData(page);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Xarid qilinganlar',
            iconCheck: true,
            icon: IconButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title:
                          const Text("Barchasini o\'chirishni xoxlaysizmi ?"),
                      actions: [
                        CupertinoDialogAction(
                            onPressed: () async {
                              isLoading = true;
                              setState(() {});
                              Navigator.pop(context);
                              HttpResult response = await repository
                                  .deleteHistorySoldList(userId);
                              if (response.isSuccess) {
                                page = 1;
                                setState(() {
                                  delete=false;
                                  isLoading = false;
                                });
                                getHistoryData(page);
                              }
                            },
                            child: const Text(
                              "Ha",
                              style: TextStyle(
                                  color: AppColor.blue100,
                                  fontWeight: FontWeight.w500),
                            )),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Yo\'q",
                            style: TextStyle(
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
              icon: const Icon(
                Icons.delete,
                size: kToolbarHeight * 0.5,
              ),
              color: Colors.white,
            )),
      ),
      body: StreamBuilder(
        stream: historyProductBloc.getAllHistoryModel,
        builder: (context, AsyncSnapshot<AllHistoryModel> snapshot) {
          if (snapshot.hasData) {
            List<HistoryInfo> historymodel = snapshot.data!.data;
            return historymodel.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: historymodel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kToolbarHeight * 0.15),
                    itemBuilder: (context, index) {
                      if (index == historymodel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
                      List<HistoryInfoData> historyData =
                          historymodel[index].data;
                      return historymodel[index].delete==0?
                        Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(kToolbarHeight * 0.5),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.blue100,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: kToolbarHeight * 0.1),
                        padding: const EdgeInsets.all(kToolbarHeight * 0.1),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextWidgetFade(
                                  text: historymodel[index].orderTime,
                                  textSize: kToolbarHeight * 0.35,
                                  fontWeight: FontWeight.bold),
                              ListView.builder(
                                primary: false,
                                itemCount: historyData.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top: kToolbarHeight * 0.1),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextWidgetFade(
                                                  text: historyData[index].name,
                                                  textSize:
                                                      kToolbarHeight * 0.27,
                                                  fontWeight: FontWeight.w600),
                                              TextWidgetFade(
                                                  text: historyData[index].info,
                                                  textSize:
                                                      kToolbarHeight * 0.25,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    kToolbarHeight * 0.05),
                                            child: Column(
                                              children: [
                                                TextWidgetFade(
                                                    text:
                                                        '${historyData[index].count}'
                                                        ' ${historyData[index].type}',
                                                    textSize:
                                                        kToolbarHeight * 0.28,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                TextWidgetFade(
                                                    text:
                                                        NumberType.numberPrice(
                                                            historyData[index]
                                                                .price
                                                                .toString()),
                                                    textSize:
                                                        kToolbarHeight * 0.25,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextWidgetFade(
                                            text: NumberType.numberPrice(
                                                historyData[index]
                                                    .allPrice
                                                    .toString()),
                                            textSize: kToolbarHeight * 0.29,
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
                                      'Buyurtmachini ismi : ${historymodel[index].userName}'),
                                  buildTextWidget(
                                      'Yetkazib berish manzili : ${historymodel[index].address}'),
                                  buildTextWidget(
                                      'Muljal :${historymodel[index].muljal}'),
                                  buildTextWidget(
                                      'Buyurtmachini telefon raqami : ${historymodel[index].addressPhoneNumber}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.all(kToolbarHeight * 0.2),
                                    child: TextWidgetFade(
                                      text: 'umumiy summa ',
                                      textSize: kToolbarHeight * 0.3,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        kToolbarHeight * 0.2),
                                    child: TextWidgetFade(
                                      text: NumberType.numberPrice(
                                          historymodel[index]
                                              .totalPrice
                                              .toString()),
                                      textSize: kToolbarHeight * 0.29,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  AcceptSentDateTime(historymodel[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.blue100,
                                    borderRadius: BorderRadius.circular(
                                        kToolbarHeight * 0.4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kToolbarHeight * 0.25,
                                      vertical: kToolbarHeight * 0.15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: historymodel[index]
                                            .acceptedTime
                                            .isEmpty,
                                        child: const Text(
                                          'Buyurtmani qabul qildim',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: kToolbarHeight * 0.25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Visibility(
                                        visible: historymodel[index]
                                            .acceptedTime
                                            .isNotEmpty,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: AppColor.white,
                                              size: kToolbarHeight * 0.4,
                                            ),
                                            Text(
                                              historymodel[index].acceptedTime,
                                              style: const TextStyle(
                                                fontSize: kToolbarHeight * 0.25,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):Container();
                    },
                  )
                : const Center(
                    child: Text('Hech narsa topilmadi'),
                  );
          }
          return const CategoryShimmer();
        },
      ),
    );
  }

  void getHistoryData(int page) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt('userId')!;
    await historyProductBloc.allUserHistory(userId, page);
    page++;
    setState(() {});
  }

  buildTextWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: kToolbarHeight * 0.26, fontWeight: FontWeight.w500),
    );
  }

  void AcceptSentDateTime(HistoryInfo historyModel) async {
    if (historyModel.acceptedTime == '') {
      String date =
          DateFormat("MMM dd, yyyy H:mm ").format(DateTime.now()).toString();
      HttpResult response =
          await repository.acceptedProducts(historyModel.id, date);
      if (response.isSuccess) {
        getHistoryData(page);
        setState(() {
          delete=true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                "Xabar",
                style: TextStyle(color: AppColor.blue100),
              ),
              content: const Text(
                'Biz bilan xarid qilganingizdan minnatdormiz !',
                style: TextStyle(fontSize: kToolbarHeight*0.25),
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
