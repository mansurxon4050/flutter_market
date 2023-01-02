// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/model/http_result.dart';
import 'package:market/widget/button/submit_button.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/loading/loading_widget.dart';

import '../../../api/repository.dart';
import '../../../bloc/category_bloc/categories_bloc.dart';
import '../../../color/color.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen(
      {Key? key,
      required this.title,
      required this.name,
      required this.id,
      required this.image})
      : super(key: key);
  final String title, name, image;
  final int id;

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  Repository repository = Repository();
  TextEditingController nameController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool wait = false;

  @override
  void initState() {
    nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategoriy ${widget.title}'),
        backgroundColor: AppColor.blue,
      ),
      body: wait
          ? LoadingWidget(isLoading: wait)
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1000,
                          maxHeight: 1000,
                          imageQuality: 100,
                        );
                        if (pickedFile != null) {
                          _imageFile = pickedFile;
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 5),
                              content: Text("Rasm tanlab olindi !",
                                  style: TextStyle(
                                      fontSize: kToolbarHeight * 0.28,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          _imageFile == null
                              ? Container(
                                  height: kToolbarHeight * 4,
                                  width: kToolbarHeight * 4,
                                  margin: const EdgeInsets.only(
                                      top: kToolbarHeight * 0.2,
                                      bottom: kToolbarHeight * 0.2),
                                  decoration: BoxDecoration(
                                    color: AppColor.blue10,
                                    borderRadius: BorderRadius.circular(
                                        kToolbarHeight * 0.2),
                                  ),
                                  child: CustomNetworkImage(
                                    imageUrl: widget.image,
                                    weight: kToolbarHeight,
                                    height: kToolbarHeight,
                                  ),
                                )
                              : Container(
                                  height: kToolbarHeight * 4,
                                  width: kToolbarHeight * 4,
                                  margin: const EdgeInsets.only(
                                      top: kToolbarHeight * 0.2,
                                      bottom: kToolbarHeight * 0.2),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(
                                        kToolbarHeight * 0.2),
                                  ),
                                  child: Icon(Icons.check_circle),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ichimliklar',
                      label: Text('kategoriya nomi'),
                      enabledBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacer(),
                SubmitButton(
                    onTap: () async {
                      if (nameController.text.isNotEmpty) {
                        setState(() {
                          wait = true;
                        });
                        HttpResult response;
                        var data = {
                          "id": widget.id,
                          "name": nameController.text,
                          "info": '',
                        };
                        if (widget.title == 'qoshish') {
                          if (_imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text("Rasmni tanlang ?",
                                    style: TextStyle(
                                        fontSize: kToolbarHeight * 0.28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            response = await repository.addCategory(
                                _imageFile!, 'admin/category/add', data);
                            checkResponse(context, response);
                          }
                        } else if (widget.title == 'tahrirlash') {
                          if (_imageFile != null) {
                            response = await repository.addCategory(
                                _imageFile!, 'admin/category/update', data);
                            checkResponse(context, response);
                          } else {
                            response = await repository.addCategoryString(data);
                            checkResponse(context, response);
                          }
                        }
                      }
                    },
                    buttonName: widget.title),
              ],
            ),
    );
  }

  void checkResponse(BuildContext context, HttpResult response) async {
    setState(() {
      wait = false;
    });
    if (response.isSuccess) {
      CenterDialog.messageDialog(
          context,
          widget.id == 0 ? 'Qoshildi' : 'Tahrirlandi',
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
}
