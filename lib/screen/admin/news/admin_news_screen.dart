import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/screen/admin/news/add_news.dart';
import 'package:market/screen/admin/product/products_screen.dart';
import 'package:market/widget/image_load/network_image.dart';

import '../../../bloc/person/news_paper_bloc.dart';
import '../../../color/color.dart';
import '../../../model/person/news_paper_model.dart';
import '../../../widget/shimmer/home_shimmer.dart';
import '../../../widget/text_widget.dart';

class AdminNewsScreen extends StatefulWidget {
  const AdminNewsScreen({Key? key}) : super(key: key);

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    getNewsData();
    super.initState();
  }

  void getNewsData() async {
    await newsPaperBloc.newsPaperInfo();
  }

  @override
  Widget build(BuildContext context) {
    final scales = MediaQuery.of(context).size.aspectRatio;
    final scale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('admin.news')),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddNewsScreen(title:"qoshish",id: 0, name: '', info: '',image: '',),
                    ));
              },
              icon: const Icon(
                Icons.add,
                size: kToolbarHeight * 0.5,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: newsPaperBloc.getItemInfoProducts,
        builder: (context, AsyncSnapshot<NewsPaperModel> snapshot) {
          if (snapshot.hasData) {
            isLoading != isLoading;
            List<NewsPaperDataModel> newsPaperDataModel = snapshot.data!.data;
            return newsPaperDataModel.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: newsPaperDataModel.length,
                    itemBuilder: (context, index) {
                      return Container(
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
                        height:60/scales,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            CustomNetworkImage(
                                imageUrl: newsPaperDataModel[index].image,
                                height: 55/scales,
                                weight: 55/scales),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgetFade(
                                      text:
                                          'Id : ${newsPaperDataModel[index].id}',
                                      textSize: 16/scale,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                          'Nomi : ${newsPaperDataModel[index].name}',
                                      textSize: 16/scale,
                                      fontWeight: FontWeight.bold),
                                  TextWidgetFade(
                                      text:
                                          'info : ${newsPaperDataModel[index].info}',
                                      textSize: 16/scale,
                                      fontWeight: FontWeight.w500),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddNewsScreen(
                                            title:"tahrirlash",
                                              id: newsPaperDataModel[index].id,
                                              name: newsPaperDataModel[index]
                                                  .name,
                                              info: newsPaperDataModel[index]
                                                  .info,image: newsPaperDataModel[index].image,),
                                        ));
                                  },
                                  child: AdminIcon.editIcon(context),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: AdminIcon.deleteIcon(context),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('Hech narsa topilmadi'),
                  );
          }
          return const HomeScreenShimmer();
        },
      ),
    );
  }
}
