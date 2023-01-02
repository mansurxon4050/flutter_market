import 'dart:async';

import 'package:flutter/material.dart';
import 'package:market/screen/person/ship/ship_item_info_screen.dart';
import 'package:market/utils/number_format.dart';

import '../../../api/repository.dart';
import '../../../bloc/person/history_bloc.dart';
import '../../../color/color.dart';
import '../../../model/person/history_model.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/shimmer/category_shimmer.dart';
import '../../../widget/text_widget.dart';

class ShipScreen extends StatefulWidget {
  const ShipScreen({Key? key}) : super(key: key);

  @override
  State<ShipScreen> createState() => _ShipScreenState();
}
// Noti.showBigTextNotification(title: 'Message title', body:"royxat", fn: flutterLocalNotificationsPlugin);

class _ShipScreenState extends State<ShipScreen> {
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  late int userId;

  @override
  void initState() {
    getHistoryData(page);
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     getHistoryData(page);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yetkazib berish",style: TextStyle(fontSize: 20/scale),),
        backgroundColor: AppColor.blue,
      ),
      body: StreamBuilder(
        stream: historyProductBloc.getAllHistoryModels,
        builder: (context, AsyncSnapshot<AllHistoryModel> snapshot) {
          if (snapshot.hasData) {
            List<HistoryInfo> historyModel = snapshot.data!.data;
            return historyModel.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: historyModel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding:  EdgeInsets.symmetric(
                        horizontal: 2/scales),
                    itemBuilder: (context, index) {
                      if (index == historyModel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SHipItemInfoScreen(model: historyModel[index]),
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
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
                                            'Id:${historyModel[index].id}   summa:${NumberType.numberPrice(historyModel[index].totalPrice.toString())}',
                                        textSize: 18/scale,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetFade(
                                        text:
                                            'Ism: ${historyModel[index].userName}   Id: ${historyModel[index].userId}',
                                        textSize: 16/scale,
                                        fontWeight: FontWeight.bold),
                                    TextWidgetFade(
                                        text:
                                            'tel : ${historyModel[index].addressPhoneNumber}   ${historyModel[index].orderTime}',
                                        textSize: 16/scale,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetFade(
                                        text:
                                            'Manzil : ${historyModel[index].address}',
                                        textSize: 16/scale,
                                        fontWeight: FontWeight.w500),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.circle,color: Colors.red,size: kToolbarHeight*0.35,),
                                        TextWidgetFade(
                                            text:
                                            historyModel[index].make,
                                            textSize: 16/scale,
                                            fontWeight: FontWeight.w500),
                                        const Icon(Icons.circle,color: Colors.yellow,size: kToolbarHeight*0.35,),
                                        TextWidgetFade(
                                            text:
                                            historyModel[index].ready,
                                            textSize: 16/scale,
                                            fontWeight: FontWeight.w500),
                                        const Icon(Icons.circle,color: Colors.green,size: kToolbarHeight*0.35,),
                                        TextWidgetFade(
                                            text:
                                            historyModel[index].driver,
                                            textSize: 16/scale,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
    await historyProductBloc.allHistories(page,"normalUser");
    page++;
    setState(() {});
  }

}
