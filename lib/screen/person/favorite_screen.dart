import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/database/database_helper.dart';
import 'package:market/screen/home/product_item_screen.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/repository.dart';
import '../../bloc/person/favorite_bloc.dart';
import '../../color/color.dart';
import '../../model/http_result.dart';
import '../../model/person/favorite_model.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/image_load/network_image.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/category_shimmer.dart';
import '../../widget/shimmer/home_shimmer.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin<FavoriteScreen> {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  late int userId;

  @override
  void initState() {
    getUserId();
    getData();

    setState(() {});
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
            title: translate('favorite'),
            iconCheck: true,
            icon: IconButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(translate('deleteAll'),
                         ),
                      actions: [
                        CupertinoDialogAction(
                            onPressed: () async {
                              isLoading = true;
                              setState(() {});
                              Navigator.pop(context);
                              HttpResult response =
                                  await repository.deleteFavoriteList(userId);
                              if (response.isSuccess) {
                                setState(() {
                                  isLoading = false;
                                });
                                await Databasehelper.deleteFavorColumn();
                                getData();
                              }
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
              icon: const Icon(
                Icons.delete,
                size: kToolbarHeight * 0.5,
              ),
              color: Colors.white,
            )),
      ),
      body: StreamBuilder(
        stream: favoriteProductBloc.getFavoriteProducts,
        builder: (context, AsyncSnapshot<FavoriteModel> snapshot) {
          if (snapshot.hasData) {
            isLoading != isLoading;
            List<FavoriteProductItemInfo> productModel = snapshot.data!.data;
            return productModel.isNotEmpty
                ? GridView.builder(
                    itemCount: productModel.length,
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (_, index) {
                      if (index == productModel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      return InkWell(
                        borderRadius:
                            BorderRadius.circular(kToolbarHeight * 0.4),
                        highlightColor: AppColor.blue10,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return ProductItemScreen(
                              olPage: true,
                              id: productModel[index].id,
                              productName: productModel[index].name,
                            );
                          })));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kToolbarHeight * 0.15),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: kToolbarHeight * 0.09),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kToolbarHeight * 0.4),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColor.blue100, blurRadius: 3)
                              ]),
                          child: Column(
                            children: [
                              Flexible(
                                child: TextWidgetFade(
                                    text: productModel[index].name,
                                    textSize: kToolbarHeight*0.25,
                                    fontWeight: FontWeight.bold),
                              ),
                              CustomNetworkImage(
                                height: kToolbarHeight * 1.5,
                                weight: kToolbarHeight * 1.5,
                                imageUrl: productModel[index].image,
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kToolbarHeight * 0.1),
                                  alignment: Alignment.center,
                                  child: TextWidgetFade(
                                    text: productModel[index].info,
                                    fontWeight: FontWeight.w500,
                                    textSize:  kToolbarHeight*0.22,
                                  )),
                              TextWidgetFade(
                                  text: NumberType.numberPrice(
                                    productModel[index].discountPrice >
                                            0
                                        ? '${productModel[index].discountPrice}'
                                        : '${productModel[index].price}',
                                  ),
                                  textSize: kToolbarHeight*0.27,
                                  fontWeight: FontWeight.w500),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                :  Center(
                    child: Text( translate('empty')),
                  );
          }
          return const CategoryShimmer();
        },
      ),
    );
  }

  void getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getInt('userId')!;
    setState(() {});
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getInt('userId')!;
    setState(() {});
    await favoriteProductBloc.favoriteInfo(userId);
  }
}
