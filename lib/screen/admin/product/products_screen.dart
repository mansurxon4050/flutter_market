// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/model/http_result.dart';
import 'package:market/screen/admin/product/product_add_screen.dart';
import 'package:market/screen/admin/product/search_products.dart';
import 'package:market/utils/number_format.dart';

import '../../../api/repository.dart';
import '../../../bloc/product_bloc/product_item_bloc.dart';
import '../../../color/color.dart';
import '../../../model/product/item_product_model.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/shimmer/home_shimmer.dart';
import '../../../widget/text_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin<ProductsScreen> {
  @override
  bool get wantKeepAlive => true;
  Repository repository = Repository();
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getData();
    setState(() {});
    _scrollController.addListener(() {
      print("scrolllllllllll");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    final scales = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('admin.products')),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminSearchProduct(),
                    ));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductAddScreen(
                        title: 'add',
                        id: 0,
                        type: '',
                        price: 0,
                        star: 0,
                        info: '',
                        discount: 0,
                        count: 0,
                        cat: '',
                        desc: '',
                        disPrice: 0,
                        name: '',
                        image: '',
                      ),
                    ));
              },
              icon: const Icon(
                Icons.add,
                size: kToolbarHeight * 0.5,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: productItemBloc.getItemInfoProducts,
        builder: (context, AsyncSnapshot<ItemProductModel> snapshot) {
          if (snapshot.hasData) {
            isLoading != isLoading;
            List<ProductItemInfo> productModel = snapshot.data!.data;
            return productModel.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productModel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 3 / scales),
                    itemBuilder: (context, index) {
                      if (index == productModel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColor.blue100,
                                blurRadius: 4,
                              )
                            ]),
                        height: 50 / scales,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'http://mansurer.beget.tech/storage/${productModel[index].image}',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.black,
                                  ),
                                ),
                                height: 40 / scales,
                                width: 40 / scales,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgetFade(
                                      text: 'Id : ${productModel[index].id}',
                                      textSize: 16 / scale,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                          'Nomi : ${productModel[index].name}',
                                      textSize: 18 / scale,
                                      fontWeight: FontWeight.bold),
                                  TextWidgetFade(
                                      text:
                                          'info : ${productModel[index].info}',
                                      textSize: 16 / scale,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                          'narxi : ${NumberType.numberPrice(productModel[index].price.toString())}',
                                      textSize: 16 / scale,
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
                                          builder: (context) =>
                                              ProductAddScreen(
                                            title: 'update',
                                            id: productModel[index].id,
                                            image: productModel[index].image,
                                            name: productModel[index].name,
                                            desc:
                                                productModel[index].description,
                                            info: productModel[index].info,
                                            cat: productModel[index].category,
                                            type: productModel[index].type,
                                            disPrice: productModel[index]
                                                .discountPrice,
                                            count: productModel[index].count,
                                            discount:
                                                productModel[index].discount,
                                            star: productModel[index].star,
                                            price: productModel[index].price,
                                          ),
                                        ));
                                  },
                                  child: AdminIcon.editIcon(context),
                                ),
                                InkWell(
                                  onTap: () {
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
                                                          .deleteProduct(
                                                              productModel[
                                                                      index]
                                                                  .id);
                                                  if (response.isSuccess) {
                                                    CenterDialog.messageDialog(
                                                        context,
                                                        'ochirildi !',
                                                        () => Navigator.pop(
                                                            context));
                                                    await productItemBloc
                                                        .allProductInfo(page);
                                                  } else {
                                                    if (response.status == -1) {
                                                      CenterDialog
                                                          .networkErrorDialog(
                                                              context);
                                                    } else {
                                                      CenterDialog.errorDialog(
                                                        context,
                                                        Utils.serverErrorText(
                                                            response),
                                                      );
                                                    }
                                                  }
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

  void getData() async {
    await productItemBloc.allProductInfo(page);
    setState(() {
      page++;
    });
  }
}

class AdminIcon {
  static editIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      child: Icon(
        Icons.edit_outlined,
        size: 12 / MediaQuery.of(context).size.aspectRatio,
        color: Colors.white,
      ),
    );
  }

  static deleteIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: Icon(
        Icons.delete,
        size: 12 / MediaQuery.of(context).size.aspectRatio,
        color: Colors.white,
      ),
    );
  }
}
