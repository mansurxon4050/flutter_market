import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/bloc/category_bloc/categories_bloc.dart';
import 'package:market/color/color.dart';
import 'package:market/screen/category/category_item_screen.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/text_widget.dart';
import '../../model/category/category_model.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/shimmer/category_shimmer.dart';
import '../../widget/shimmer/home_shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

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
    return StreamBuilder(
      stream: categoryBloc.getCategoryStream,
      builder: (context, AsyncSnapshot<CategoryInfoModel> snapshot) {
        if (snapshot.hasData) {
          List<CategoryData> categoryModel = snapshot.data!.data;
          return categoryModel.isNotEmpty
              ? GridView.builder(
                  itemCount: categoryModel.length,
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, index) {
                    if (index == categoryModel.length) {
                      return LoadingWidget(
                        key: Key(isLoading.toString()),
                        isLoading: isLoading,
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return CategoryItem(
                            title: categoryModel[index].categoryName,
                          );
                        })));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: AppColor.blue100, blurRadius: 2)
                            ]),
                        child: Column(
                          children: [
                            const Spacer(),
                            CustomNetworkImage(
                              imageUrl: categoryModel[index].image,
                              height: kToolbarHeight * 1.7,
                              weight: kToolbarHeight * 1.7,
                            ),
                            const Spacer(),
                            TextWidgetFade(
                              fontWeight: FontWeight.w500,
                              textSize: kToolbarHeight * 0.26,
                              text: categoryModel[index].categoryName,
                            ),
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
        return const CategoryShimmer();
      },
    );
  }

  void _getData() async {
    await categoryBloc.CategoryInfo();
  }
}
