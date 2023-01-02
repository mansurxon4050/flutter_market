import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:market/color/color.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/text_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/home_star_bloc/star_product_bloc.dart';
import '../../model/home/banner_model.dart';
import '../../model/home/home_model.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/home_shimmer.dart';
import 'product_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();
  bool value = false;
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    _getMoreData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double scale=MediaQuery.of(context).size.aspectRatio;
    final double textScale=MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder(
              stream: starProductBloc.getAllBanners,
              builder: (context, AsyncSnapshot<Banners> snapshot) {
                if (snapshot.hasData) {
                  List<BannerData> banner = snapshot.data!.data;
                  return banner.isEmpty
                      ? Center(
                          child: Text(translate('empty'),
                              style: const TextStyle(fontSize: 30)),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          margin: const EdgeInsets.only(top: 20),
                          child: CarouselSlider.builder(
                            itemCount: banner.length,
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              pauseAutoPlayOnTouch: true,
                              autoPlayAnimationDuration:
                                  const Duration(seconds: 3),
                              enlargeCenterPage: true,
                            ),
                            itemBuilder: (context, index, realIdx) {
                              return CustomNetworkImage(
                                  imageUrl: banner[index].image,
                                  height: MediaQuery.of(context).size.height,
                                  weight: MediaQuery.of(context).size.width);
                            },
                          ),
                        );
                }
                return  Shimmer.fromColors(
                  baseColor: AppColor.shimmerBase,
                  highlightColor: AppColor.shimmerHighlight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    height: MediaQuery.of(context).size.width * 0.6,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: starProductBloc.getAllStarProducts,
              builder: (context, AsyncSnapshot<AllStarProductModel> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data!.meta.lastPage == page - 1
                      ? isLoading = true
                      : isLoading = false;
                  List<StarProductModel> productsModel = snapshot.data!.data;
                  return productsModel.isEmpty
                      ? Center(
                          child: Text(translate('empty')),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: kToolbarHeight * 0.2,
                                      top: kToolbarHeight * 0.1),
                                  child: TextWidgetFade(
                                      text: translate('top_rating'),
                                      textSize: kToolbarHeight * 0.32,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  itemCount: productsModel.length,
                                  controller: _scrollController,
                                  gridDelegate:
                                       const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio:0.65,
                                  ),
                                  itemBuilder: (_, index) {
                                    if (index == productsModel.length) {
                                      return LoadingWidget(
                                        key: Key(isLoading.toString()),
                                        isLoading: isLoading,
                                      );
                                    }
                                    if (index == productsModel.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Opacity(
                                          opacity: isLoading ? 0.0 : 1.0,
                                          child: const SizedBox(
                                            height: 44,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.blue1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (index < 0 ||
                                        index >= productsModel.length) {
                                      return Center(
                                        child: Text(translate('product_no')),
                                      );
                                    }
                                    return InkWell(
                                      highlightColor: AppColor.blue10,
                                      borderRadius: BorderRadius.circular(
                                        kToolbarHeight * 0.4),
                                      onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: ((context) {
                                        return ProductItemScreen(
                                          olPage: false,
                                          id: productsModel[index].id,
                                          productName:
                                              productsModel[index].name,
                                        );
                                      })));
                                    },
                                    child: InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    kToolbarHeight * 0.4),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: AppColor.blue10,
                                                  blurRadius: 4)
                                            ]),
                                        child: Column(
                                          children: [
                                            TextWidgetFade(
                                                text:
                                                    productsModel[index].name,
                                                textSize:16/textScale,
                                                fontWeight: FontWeight.w700),
                                            Container(
                                              margin: const EdgeInsets.all(2),
                                              child: CustomNetworkImage(
                                                imageUrl: productsModel[index]
                                                    .image,
                                                height: 40/scale,
                                                weight: 40/scale,
                                              ),
                                            ),
                                            TextWidgetFade(
                                                text:
                                                    productsModel[index].info,
                                                textSize:14/textScale,
                                                fontWeight: FontWeight.w500),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                buildIcon(true),
                                                buildIcon(true),
                                                buildIcon(true),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextWidgetFade(
                                                    text: NumberFormat
                                                        .compactCurrency(
                                                      decimalDigits: 0,
                                                      symbol: '',
                                                    ).format(
                                                        productsModel[index]
                                                            .star),
                                                    textSize:14/textScale,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                      );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                }
                return const HomeScreenShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _getMoreData(int index) async {
    await starProductBloc.allStarProducts(page);
    await starProductBloc.allBanners();
    page++;
    setState(() {});
  }

  buildIcon(bool check) {
    return Icon(check ? Icons.star : Icons.star_border,
        color: AppColor.blue100, size: kToolbarHeight * 0.35);
  }
}
