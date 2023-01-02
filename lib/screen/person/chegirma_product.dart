import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/app_bar/person_app_bar.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/text_widget.dart';

import '../../bloc/category_bloc/categories_products_bloc.dart';
import '../../color/color.dart';
import '../../model/category/category_product_model.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/category_shimmer.dart';
import '../home/product_item_screen.dart';

class ChegirmaProductScreen extends StatefulWidget {
  const ChegirmaProductScreen({Key? key}) : super(key: key);

  @override
  State<ChegirmaProductScreen> createState() => _ChegirmaProductScreenState();
}

class _ChegirmaProductScreenState extends State<ChegirmaProductScreen> {
  int page = 1;
  bool isLoading = false;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getDiscountProductData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getDiscountProductData(page);
      }
    });
    super.initState();
  }

  void getDiscountProductData(int page) async {
    await categoryProductsBloc.allDiscountProductsMethod(page);
    page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    final scaleI=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: translate('discount_product'),
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Colors.black,
            )),
      ),
      body: StreamBuilder(
        stream: categoryProductsBloc.getAllStarProducts,
        builder: (context, AsyncSnapshot<AllCategoryProductsModel> snapshot) {
          if (snapshot.hasData) {
            List<CategoryProductsModel> categoryProductsModel =
                snapshot.data!.data;
            return categoryProductsModel.isNotEmpty
                ? GridView.builder(
                    // shrinkWrap: true,
                    itemCount: categoryProductsModel.length,
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (_, index) {
                      if (index == categoryProductsModel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return ProductItemScreen(
                              olPage: true,
                              id: categoryProductsModel[index].id,
                              productName: categoryProductsModel[index].name,
                            );
                          })));
                        },
                        borderRadius:
                            BorderRadius.circular(kToolbarHeight * 0.4),
                        highlightColor: AppColor.blue10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: kToolbarHeight * 0.15),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kToolbarHeight * 0.4),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColor.blue100,
                                  blurRadius: 3,
                                )
                              ],
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextWidgetFade(
                                      text: categoryProductsModel[index].name,
                                      fontWeight: FontWeight.w600,
                                      textSize:15/scale,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomNetworkImage(
                                  imageUrl: categoryProductsModel[index].image,
                                  height: 40/scaleI,
                                  weight: 40/scaleI,
                                ),
                              ),
                              TextWidgetFade(
                                  text: categoryProductsModel[index].info,
                                  textSize: 14/scale,
                                  fontWeight: FontWeight.w500),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical:5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        NumberType.numberPrice(categoryProductsModel[index].price.toString()),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 1,
                                        style:  TextStyle(
                                            fontSize: 14/scale,
                                            color: Colors.black87,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: kToolbarHeight * 0.06),
                                      decoration: BoxDecoration(
                                        color: AppColor.blue100,
                                        borderRadius: BorderRadius.circular(
                                            kToolbarHeight * 0.3),
                                      ),
                                      child: Text(
                                        '-${categoryProductsModel[index].discount} %',
                                        style:  TextStyle(
                                          fontSize: 14/scale,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextWidgetFade(
                                  text:
                                      NumberType.numberPrice(categoryProductsModel[index].discountPrice.toString()),
                                  fontWeight: FontWeight.w700,
                                  textSize: kToolbarHeight * 0.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                :  Center(
                    child: Text(translate('product_no'),),
                  );
          }
          return const CategoryShimmer();
        },
      ),
    );
  }
}
