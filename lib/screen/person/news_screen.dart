import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/bloc/person/news_paper_bloc.dart';

import '../../model/person/news_paper_model.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/shimmer/category_shimmer.dart';
import '../../widget/shimmer/home_shimmer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    getNewsData();

    setState(() {});
    super.initState();
  }

  void getNewsData() async {
    await newsPaperBloc.newsPaperInfo();
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
            title: translate('news'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
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
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.9,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width*0.94,
                                width: MediaQuery.of(context).size.width*0.94,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(kToolbarHeight*0.25),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'http://mansurer.beget.tech//storage/${newsPaperDataModel[index].image}',
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.black,
                                      ),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.width*0.94,
                                    width:
                                        MediaQuery.of(context).size.width*0.94,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height:
                                      (MediaQuery.of(context).size.width *0.94) /
                                          2,
                                  width: MediaQuery.of(context).size.width*0.94,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(kToolbarHeight*0.25),
                                      bottomLeft: Radius.circular(kToolbarHeight*0.25),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(0, 0, 0, 0),
                                        Color(0xFF000000),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: kToolbarHeight*0.25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: kToolbarHeight*0.8, bottom: kToolbarHeight*0.15),
                                        child: Text(
                                          newsPaperDataModel[index].name,
                                          style: const TextStyle(
                                            // fontFamily: AppColor.fontFamilyProduct,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: kToolbarHeight*0.28,
                                            height: 28 / 22,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: kToolbarHeight*0.8, bottom:kToolbarHeight*0.15),
                                        child: Text(
                                          newsPaperDataModel[index].info,
                                          style: const TextStyle(
                                            // fontFamily: AppColor.fontFamilyProxima,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: kToolbarHeight*0.27,
                                            height: 22 / 15,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: kToolbarHeight*0.15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('Hech narsa topilmadi'),
                  );
          }
          return const CategoryShimmer();
        },
      ),
    );
  }
}
