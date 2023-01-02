// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:market/database/database_helper.dart';
import 'package:market/model/database_model/add_cart_database_model.dart';
import 'package:market/utils/number_format.dart';
import '../../api/repository.dart';
import '../../bloc/home_star_bloc/star_product_bloc.dart';
import '../../bloc/product_bloc/product_item_bloc.dart';
import '../../color/color.dart';
import '../../model/http_result.dart';
import '../../model/product/item_product_model.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/shimmer/category_shimmer.dart';

class ProductItemScreen extends StatefulWidget {
  final int id;
  final String productName;
  final bool olPage;

  const ProductItemScreen(
      {Key? key,
      required this.id,
      required this.productName,
      required this.olPage})
      : super(key: key);

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  bool isStarClick1 = false;
  bool isStarClick2 = false;
  bool isStarClick3 = false;
  bool isLoading = false;
  int isLike = 0;
  int count = 1;
  int starCount = 0;
  List list = [];
  Repository repository = Repository();

  @override
  void initState() {
    getData();
    getDatabaseInfo();
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final textScale=MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        await starProductBloc.allStarProducts(1);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBarWidget(
            onTap: () async {
              Navigator.pop(context);
              await starProductBloc.allStarProducts(1);
            },
            title: widget.productName,
            iconCheck: true,
            icon: IconButton(
                onPressed: () async {
                  LikeResponse();
                },
                icon: Icon(
                  isLike==0?
                  Icons.favorite_outline:Icons.favorite,
                  size: 30/textScale,
                  color: isLike == 0 ? Colors.white : Colors.red,
                )),
          ),
        ),
        body: StreamBuilder(
          stream: productItemBloc.getItemInfoProducts,
          builder: (context, AsyncSnapshot<ItemProductModel> snapshot) {
            if (snapshot.hasData) {
              isLoading != isLoading;
              List<ProductItemInfo> productModel = snapshot.data!.data;
              return productModel.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://mansurer.beget.tech/storage/${productModel[0].image}',
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                    color: AppColor.blue1,
                                  )),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.black,
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ],
                          ),
                          Arc(
                            height: MediaQuery.of(context).size.height * 0.06,
                            edge: Edge.TOP,
                            clipShadows: [
                              ClipShadow(color: AppColor.blue100, elevation: 1)
                            ],
                            arcType: ArcType.CONVEY,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.08),
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        productModel[0].name,
                                        style: TextStyle(
                                          fontSize: 18*textScale,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        productModel[0].info,
                                        style: TextStyle(
                                          fontSize: 16*textScale,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.007,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (starCount < 1) {
                                                starResponse(
                                                    1, true, false, false);
                                              }
                                            },
                                            child: buildStarIcon(
                                                context, isStarClick1),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.001,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (starCount < 2) {
                                                starResponse(
                                                    2, true, true, false);
                                              }
                                            },
                                            child: buildStarIcon(
                                                context, isStarClick2),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.001,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (starCount < 3) {
                                                starResponse(
                                                    3, true, true, true);
                                              }
                                            },
                                            child: buildStarIcon(
                                                context, isStarClick3),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (count > 1) {
                                                count--;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kToolbarHeight * 0.6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColor.blue100
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  CupertinoIcons.minus,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  color: AppColor.blue100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            count.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15*textScale,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            productModel[0].type,
                                            style: TextStyle(
                                                fontSize: 20/textScale,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (productModel[0].count >
                                                  count) {
                                                count++;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kToolbarHeight * 0.6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColor.blue100
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  CupertinoIcons.plus,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  color: AppColor.blue100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                        NumberFormat.compactCurrency(
                                          decimalDigits: 0,
                                          symbol: '',
                                        ).format(productModel[0].star),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12*textScale,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible: productModel[0].discount > 0,
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01),
                                          decoration: BoxDecoration(
                                            color: AppColor.blue100,
                                            borderRadius: BorderRadius.circular(
                                                kToolbarHeight * 0.5),
                                          ),
                                          child: Text(
                                            '-${productModel[0].discount}'
                                            '%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        NumberType.numberPrice(
                                            productModel[0].price.toString()),
                                        style: TextStyle(
                                          fontSize: 14*textScale,
                                          decoration:
                                              productModel[0].discountPrice > 0
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Visibility(
                                        visible: productModel[0].discount > 0,
                                        child: Text(
                                          NumberType.numberPrice(productModel[0]
                                              .discountPrice
                                              .toString()),
                                          style: TextStyle(
                                            fontSize: 14*textScale,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Text(
                                    textAlign: TextAlign.justify,
                                    productModel[0].description,
                                    style: TextStyle(
                                        fontSize: 14*textScale,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                NumberType.numberPrice(
                                  productModel[0].discountPrice > 0
                                      ? '${productModel[0].discountPrice * count}'
                                      : '${productModel[0].price * count}',
                                ),
                                style: TextStyle(
                                  fontSize: 18/textScale,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blue100,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          AppColor.blue100)),
                                  onPressed: () async {
                                    SaveDatabaseProduct(productModel[0]);
                                    ShowMessage(
                                        context, translate('add_to_cart_save'));
                                  },
                                  icon: Icon(
                                    CupertinoIcons.cart_badge_plus,
                                    color: Colors.white,
                                    size:30/textScale,
                                  ),
                                  label: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      translate('add_to_cart'),
                                      style: TextStyle(
                                        fontSize: 12*textScale,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(translate('product_not_found')),
                    );
            }
            return const CategoryShimmer();
          },
        ),
      ),
    );
  }

  void getData() async {
    await productItemBloc.productInfo(widget.id);
  }

  void getDatabaseInfo() async {
    list = await Databasehelper.instance1.getInfoProducts(widget.id);
    if (list.isNotEmpty) {
      isLike = list[0]['favorite']!;
      starCount = list[0]['star']!;
      switch (starCount) {
        case 1:
          {
            isStarClick1 = true;
          }
          break;
        case 2:
          {
            isStarClick1 = true;
            isStarClick2 = true;
          }
          break;
        case 3:
          {
            isStarClick1 = true;
            isStarClick2 = true;
            isStarClick3 = true;
          }
          break;
      }
      setState(() {});
    }
  }

  void LikeResponse() async {
    if (isLike == 0) {
      HttpResult response = await repository.favorite(widget.id);
      if (response.isSuccess) {
        ShowMessage(context, translate('add_to_favorite'));
        isLike = 1;
        setState(() {});
        await Databasehelper.instance1.add1(ProductStarFavorInfoModel(
          productId: widget.id,
          star: 0,
          favorite: 1,
        ));
      }
    }
  }

  void starResponse(
      int starAddCount, bool star1, bool star2, bool star3) async {
    HttpResult response =
        await repository.addStar(widget.id, starAddCount - starCount);
    if (response.isSuccess) {
      await Databasehelper.instance1.add1(ProductStarFavorInfoModel(
          favorite: isLike, star: starAddCount, productId: widget.id));
      getData();
      getDatabaseInfo();
      isStarClick1 = star1;
      isStarClick2 = star2;
      isStarClick3 = star3;
      setState(() {});
    }
  }

  void SaveDatabaseProduct(ProductItemInfo productModel) async {
    int price = productModel.discountPrice > 0
        ? productModel.discountPrice
        : productModel.price;
    await Databasehelper.instance.add(Grocery(
      productId: productModel.id,
      name: productModel.name,
      image: productModel.image,
      info: productModel.info,
      category: productModel.category,
      price: price,
      allPrice: price * count,
      count: count,
      type: productModel.type,
    ));
    setState(() {});
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> ShowMessage(
      BuildContext context, String message) {
    final scale=MediaQuery.of(context).textScaleFactor;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message,
            style:  TextStyle(
                fontSize: 16/scale,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }
}

buildStarIcon(BuildContext context, bool isStarClick) {
  return Icon(
    isStarClick ? Icons.star : Icons.star_border,
    color: AppColor.blue100,
  );
}
