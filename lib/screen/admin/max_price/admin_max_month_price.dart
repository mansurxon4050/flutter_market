import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/screen/admin/user/user_item.dart';
import 'package:market/utils/number_format.dart';

import '../../../api/repository.dart';
import '../../../bloc/admin/admin_users.dart';
import '../../../color/color.dart';
import '../../../model/admin/users_model.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/text_widget.dart';
class AdminMaxPrice extends StatefulWidget {
  const AdminMaxPrice({Key? key}) : super(key: key);

  @override
  State<AdminMaxPrice> createState() => _AdminMaxPriceState();
}

class _AdminMaxPriceState extends State<AdminMaxPrice> {
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  late int userId;
  TextEditingController textcontroller = TextEditingController();

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
              stream: allUsersBloc.getAllUsers,
              builder: (context, AsyncSnapshot<AllUsersModel> snapshot) {
                if (snapshot.hasData) {
                  List<UserData> userModel = snapshot.data!.data;
                  return userModel.isNotEmpty
                      ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userModel.length,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kToolbarHeight * 0.15),
                    itemBuilder: (context, index) {
                      if (index == userModel.length) {
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
                                builder: (context) => AdminUserItem(
                                    userData: userModel[index]),
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColor.blue100,
                                  blurRadius: 4,
                                )
                              ]),
                          height: kToolbarHeight * 1.5,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TextWidgetFade(
                                        text:
                                        'Id : ${userModel[index].id} '
                                            '  role_id :  ${userModel[index].roleId}',
                                        textSize: kToolbarHeight * 0.3,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetFade(
                                        text:
                                        'Ism :  ${userModel[index].name}',
                                        textSize: kToolbarHeight * 0.30,
                                        fontWeight: FontWeight.bold),
                                    TextWidgetFade(
                                        text:
                                        'phone number :  ${userModel[index].phoneNumber}',
                                        textSize: kToolbarHeight * 0.25,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetFade(
                                        text:
                                        'oylik xarid : ${NumberType.numberPrice(userModel[index].monthPrice.toString())}',
                                        textSize: kToolbarHeight * 0.25,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : const Center(
                    child: Text('Hech narsa topilmadi'),
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
    await allUsersBloc.maxMonthPrice(page, search);
    page++;
    setState(() {});
  }
}
