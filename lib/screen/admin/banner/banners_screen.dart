// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/model/http_result.dart';
import 'package:market/screen/admin/product/products_screen.dart';
import 'package:market/widget/image_load/network_image.dart';

import '../../../bloc/home_star_bloc/star_product_bloc.dart';
import '../../../color/color.dart';
import '../../../model/home/banner_model.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/shimmer/home_shimmer.dart';
import 'add_banner.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({Key? key}) : super(key: key);

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();

  @override
  void initState() {
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scales = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reklamalar'),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BannerAdd(
                        id: 0,
                        title: 'qoshish',
                        image: '',
                      ),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: starProductBloc.getAllBanners,
        builder: (context, AsyncSnapshot<Banners> snapshot) {
          if (snapshot.hasData) {
            List<BannerData> bannerData = snapshot.data!.data;
            return bannerData.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: bannerData.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding:  EdgeInsets.symmetric(
                        horizontal: 2/scales,
                        vertical: 1/scales),
                    itemBuilder: (context, index) {
                      if (index == bannerData.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
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
                            CustomNetworkImage(
                              imageUrl: bannerData[index].image,
                              height: 55/scales,
                              weight: 55/scales,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BannerAdd(
                                            id: bannerData[index].id,
                                            title: 'tahrirlash',
                                            image: bannerData[index].image,
                                          ),
                                        ));
                                  },
                                  child: AdminIcon.editIcon(context),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(translate('delete')),
                                          actions: [
                                            CupertinoDialogAction(
                                                onPressed: () async {
                                                  HttpResult response =
                                                      await repository
                                                          .deleteBanner(
                                                              bannerData[index]
                                                                  .id);
                                                  checkResponse(
                                                      context, response);
                                                },
                                                child: Text(
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
                                              child: Text(
                                                translate('no'),
                                                style: const TextStyle(
                                                    color: AppColor.blue100,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                          // content: Text("Saved successfully"),
                                        );
                                      },
                                    );
                                  },
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
                : Center(
                    child: Text(translate('product_not_found')),
                  );
          }
          return const HomeScreenShimmer();
        },
      ),
    );
  }

  void _getMoreData() async {
    await starProductBloc.allBanners();
    setState(() {});
  }

  void checkResponse(BuildContext context, HttpResult response) async {
    if (response.isSuccess) {
      CenterDialog.messageDialog(
          context, 'ochirildi', () => Navigator.pop(context));
      _getMoreData();
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
  }
}
