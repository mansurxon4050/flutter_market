// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/screen/admin/product/product_add_screen.dart';
import 'package:market/screen/admin/product/products_screen.dart';

import '../../../bloc/product_bloc/product_item_bloc.dart';
import '../../../bloc/search_bloc/search_bloc.dart';
import '../../../color/color.dart';
import '../../../model/http_result.dart';
import '../../../model/search/search_model.dart';
import '../../../utils/number_format.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/text_widget.dart';

class AdminSearchProduct extends StatefulWidget {
  const AdminSearchProduct({Key? key}) : super(key: key);

  @override
  State<AdminSearchProduct> createState() => _AdminSearchProductState();
}

class _AdminSearchProductState extends State<AdminSearchProduct> {
  TextEditingController textcontroller = TextEditingController();
  int page = 1;
  bool isLoading = false;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository=Repository();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: kToolbarHeight * 0.1,
                horizontal: kToolbarHeight * 0.2),
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(kToolbarHeight * 0.4),
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.blue100, spreadRadius: 1, blurRadius: 2)
                ]),
            margin: const EdgeInsets.only(
                top: kToolbarHeight * 1,
                left: kToolbarHeight * 0.2,
                right: kToolbarHeight * 0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: AppColor.blue100,
                ),
                Expanded(
                  child: TextField(
                    controller: textcontroller,
                    style: const TextStyle(
                      color: AppColor.blue100,
                      fontWeight: FontWeight.w500,
                      fontSize: kToolbarHeight * 0.3,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && value != '') {
                        getSearchProductsData(page, value);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: translate('search'),
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        // color: AppColor.grey85,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: searchBloc.getAllSearchProductStream,
              builder:
                  (context, AsyncSnapshot<AllSearchProductsModel> snapshot) {
                if (snapshot.hasData) {
                  List<SearchProductsModel> searchProductsModel =
                      snapshot.data!.data;
                  return searchProductsModel.isNotEmpty
                      ?  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: searchProductsModel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kToolbarHeight * 0.15),
                    itemBuilder: (context, index) {
                      if (index == searchProductsModel.length) {
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
                        height: kToolbarHeight * 1.8,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl:
                                'http://mansurer.beget.tech/storage/${searchProductsModel[index].image}',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.black,
                                  ),
                                ),
                                height: kToolbarHeight * 1.3,
                                width: kToolbarHeight * 1.2,
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
                                      text: 'Id : ${searchProductsModel[index].id}',
                                      textSize: kToolbarHeight * 0.3,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                      'Nomi : ${searchProductsModel[index].name}',
                                      textSize: kToolbarHeight * 0.30,
                                      fontWeight: FontWeight.bold),
                                  TextWidgetFade(
                                      text:
                                      'info : ${searchProductsModel[index].info}',
                                      textSize: kToolbarHeight * 0.25,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                      'narxi : ${NumberType.numberPrice(searchProductsModel[index].price.toString())}',
                                      textSize: kToolbarHeight * 0.25,
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
                                                id: searchProductsModel[index].id,
                                                image: searchProductsModel[index].image,
                                                name: searchProductsModel[index].name,
                                                desc:
                                                searchProductsModel[index].description,
                                                info: searchProductsModel[index].info,
                                                cat: searchProductsModel[index].category,
                                                type: searchProductsModel[index].type,
                                                disPrice: searchProductsModel[index]
                                                    .discountPrice,
                                                count: searchProductsModel[index].count,
                                                discount:
                                                searchProductsModel[index].discount,
                                                star: searchProductsModel[index].star,
                                                price: searchProductsModel[index].price,
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
                                                      searchProductsModel[
                                                      index]
                                                          .id);
                                                  if (response.isSuccess) {
                                                    CenterDialog.messageDialog(
                                                        context,
                                                        'ochirildi !',
                                                            () => Navigator.pop(
                                                            context));
                                                    await productItemBloc
                                                        .allProductInfo(1);
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
                return Center(
                  child: Text(translate('empty')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getSearchProductsData(int page, String search) async {
    await searchBloc.allSearchProductsMethod(page, search);
    page++;
    setState(() {});
  }
}
