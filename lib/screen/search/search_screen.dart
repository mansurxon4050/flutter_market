import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/bloc/search_bloc/search_bloc.dart';
import 'package:market/color/color.dart';
import 'package:market/model/search/search_model.dart';
import '../../utils/number_format.dart';
import '../../widget/image_load/network_image.dart';
import '../../widget/loading/loading_widget.dart';
import '../../widget/text_widget.dart';
import '../home/product_item_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textcontroller = TextEditingController();
  int page = 1;
  bool isLoading = false;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:  EdgeInsets.symmetric(vertical: 2/scales, horizontal: 2/scales),
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(6/scales),
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.blue100, spreadRadius: 1, blurRadius: 2)
                ]),
            margin:  EdgeInsets.only(
                top: 25/scales, left: 6/scales, right: 6/scales),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:  Icon(Icons.arrow_back,size: 10/scales,),
                  color: AppColor.blue100,
                ),
                Expanded(
                  child: TextField(
                    controller: textcontroller,
                    style: TextStyle(
                      color: AppColor.blue100,
                      fontWeight: FontWeight.w500,
                      fontSize: 16/scale,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && value != '') {
                        getSearchProductsData(page, value);
                      }
                    },
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: translate('search'),
                      hintStyle:  TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18/scale,
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
                      ? GridView.builder(
                          // shrinkWrap: true,
                          itemCount: searchProductsModel.length,
                          controller: _scrollController,
                          gridDelegate:
                               const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                                 childAspectRatio:0.8,
                          ),
                          itemBuilder: (_, index) {
                            if (index == searchProductsModel.length) {
                              return LoadingWidget(
                                key: Key(isLoading.toString()),
                                isLoading: isLoading,
                              );
                            }
                            isLoading = false;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) {
                                      return ProductItemScreen(
                                        olPage: false,
                                        id: searchProductsModel[index].id,
                                        productName:
                                            searchProductsModel[index].name,
                                      );
                                    }),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              highlightColor: AppColor.blue10,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: AppColor.blue100,
                                          blurRadius: 2)
                                    ],
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidgetFade(
                                            text:
                                            searchProductsModel[index].name,
                                            textSize:16/scale,
                                            fontWeight: FontWeight.w700),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(2),
                                      child: CustomNetworkImage(
                                        imageUrl: searchProductsModel[index]
                                            .image,
                                        height: 40/scales,
                                        weight: 40/scales,
                                      ),
                                    ),
                                    TextWidgetFade(
                                        text:
                                        searchProductsModel[index].info,
                                        textSize:16/scale,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(translate('product_not_found')),
                        );
                }
                return  Center(
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
