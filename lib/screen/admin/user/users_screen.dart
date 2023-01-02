import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:market/bloc/admin/admin_users.dart';
import 'package:market/model/admin/users_model.dart';
import 'package:market/screen/admin/user/user_item.dart';
import 'package:market/screen/admin/user/user_search.dart';
import 'package:market/widget/text_widget.dart';

import '../../../api/repository.dart';
import '../../../color/color.dart';
import '../../../widget/loading/loading_widget.dart';
import '../../../widget/shimmer/home_shimmer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  late int userId;

  @override
  void initState() {
    getHistoryData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getHistoryData(page);
      }
    });
    super.initState();
  }

  void getHistoryData(int page) async {
    await allUsersBloc.allUsersFunction(page);
    page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scale=MediaQuery.of(context).textScaleFactor;
    final scales=MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('admin.users')),
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSearch(),));
              },
              icon: const Icon(
                Icons.search,
                color: AppColor.white,
              )),
        ],
      ),
      body: StreamBuilder(
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
                    padding: EdgeInsets.symmetric(
                        horizontal:4/scales),
                    itemBuilder: (context, index) {
                      if (index == userModel.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      isLoading = false;
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminUserItem(userData: userModel[index]),
                              ));
                        },
                        child: Container(
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
                          height: 40/scales,
                          child: Row(
                            children: [
                               SizedBox(
                                width: 6/scales,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidgetFade(
                                        text: 'Id : ${userModel[index].id} ''  role_id :  ${userModel[index].roleId}',
                                        textSize: 18/scale,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetFade(
                                        text: 'Ism :  ${userModel[index].name}',
                                        textSize: 16/scale,
                                        fontWeight: FontWeight.bold),
                                    TextWidgetFade(
                                        text:
                                            'phone number :  ${userModel[index].phoneNumber}',
                                        textSize: 16/scale,
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
          return const HomeScreenShimmer();
        },
      ),
    );
  }
}
