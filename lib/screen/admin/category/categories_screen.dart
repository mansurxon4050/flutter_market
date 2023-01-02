// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/api/repository.dart';
import 'package:market/model/http_result.dart';
import 'package:market/screen/admin/category/category_add_screen.dart';
import 'package:market/screen/admin/product/products_screen.dart';

import '../../../bloc/category_bloc/categories_bloc.dart';
import '../../../color/color.dart';
import '../../../model/category/category_model.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/image_load/network_image.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/shimmer/home_shimmer.dart';
import '../../../widget/text_widget.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository=Repository();
  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final scales=MediaQuery.of(context).size.aspectRatio;
    final scale=MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('admin.categories')),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                           const CategoryAddScreen(title: 'qoshish',id: 0,name: '',image:''),
                    ));
              },
              icon:  Icon(
                Icons.add,
                size: 15/scales,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: categoryBloc.getCategoryStream,
        builder: (context, AsyncSnapshot<CategoryInfoModel> snapshot) {
          if (snapshot.hasData) {
            List<CategoryData> categoryModel = snapshot.data!.data;
            return categoryModel.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: categoryModel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding:  EdgeInsets.symmetric(
                        horizontal: 4/scales,
                        vertical: 4/scales),
                    itemBuilder: (context, index) {
                      if (index == categoryModel.length) {
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
                        height: 50/scales,
                        child: Row(
                          children: [
                            CustomNetworkImage(
                              imageUrl: categoryModel[index].image,
                              height: 45/scales,
                              weight: 45/scales,
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
                                      text: 'Id : ${categoryModel[index].id}',
                                      textSize:16/scale,
                                      fontWeight: FontWeight.w500),
                                  TextWidgetFade(
                                      text:
                                          'Nomi : ${categoryModel[index].categoryName}',
                                      textSize:18/scale,
                                      fontWeight: FontWeight.bold),
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
                                               CategoryAddScreen(
                                                  title: 'tahrirlash',
                                                   name:categoryModel[index].categoryName,
                                                   id:categoryModel[index].id,
                                                   image:categoryModel[index].image
                                              ),
                                        ));
                                  },
                                  child: AdminIcon.editIcon(context),
                                ),
                                InkWell(
                                  onTap: () async{
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(translate('delete')),
                                          actions: [
                                            CupertinoDialogAction(
                                                onPressed: () async {
                                                  HttpResult response=await repository.deleteCategory(categoryModel[index].id);
                                                  checkResponse(context,response);
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
  void checkResponse(BuildContext context, HttpResult response) async {
    if (response.isSuccess) {
      CenterDialog.messageDialog(
          context,
          'ochirildi',
              () => Navigator.pop(context));
      await categoryBloc.CategoryInfo();
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
  void _getData() async {
    await categoryBloc.CategoryInfo();
  }
}
