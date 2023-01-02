import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/bloc/category_bloc/categories_products_bloc.dart';
import 'package:market/screen/home/product_item_screen.dart';
import 'package:market/utils/number_format.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/text_widget.dart';

import '../../bloc/category_bloc/categories_products_bloc.dart';
import '../../color/color.dart';
import '../../model/category/category_product_model.dart';
import '../../widget/app_bar/person_app_bar.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/home_shimmer.dart';

class CategoryItem extends StatefulWidget {
  final String title;

  const CategoryItem({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int page = 1;
  bool isLoading = false;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getCategoryProductData(page, widget.title);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getCategoryProductData(page, widget.title);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double scale=MediaQuery.of(context).size.aspectRatio;
    final double textScale=MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: widget.title,
            iconCheck: false,
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
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
                      childAspectRatio: 0.8,
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
                          padding:  EdgeInsets.all(kToolbarHeight * 0.15),
                          margin:  EdgeInsets.all(kToolbarHeight * 0.1),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kToolbarHeight * 0.4),
                            boxShadow: const [
                              BoxShadow(color: AppColor.blue100, blurRadius: 3)
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              TextWidgetFade(
                                text: categoryProductsModel[index].name,
                                textSize:16/textScale,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              CustomNetworkImage(
                                  imageUrl: categoryProductsModel[index].image,
                                  height: kToolbarHeight * 1.4,
                                  weight: kToolbarHeight * 1.4),
                              const Spacer(),
                              TextWidgetFade(
                                  text: categoryProductsModel[index].info,
                                  textSize:13/textScale,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              TextWidgetFade(
                                  text:NumberType.numberPrice(categoryProductsModel[index].price.toString()),
                                  textSize:14/textScale,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                :  Center(
                    child: Text(translate('product_not_found')),
                  );
          }
          return const HomeScreenShimmer();
        },
      ),
    );
  }

  void getCategoryProductData(int page, String category) async {
    await categoryProductsBloc.allCategoryProductsMethod(page, category);
    page++;
    setState(() {});
  }
}
