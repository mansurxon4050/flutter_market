// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/color/color.dart';

import '../../../api/repository.dart';
import '../../../bloc/category_bloc/categories_bloc.dart';
import '../../../bloc/person/news_paper_bloc.dart';
import '../../../model/http_result.dart';
import '../../../utils/utils.dart';
import '../../../widget/button/submit_button.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/image_load/network_image.dart';
import '../../../widget/loading/loading_widget.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.info,
    required this.title,
    required this.image,
  }) : super(key: key);
  final String title;
  final int id;
  final String name;
  final String image;
  final String info;

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  Repository repository = Repository();
  TextEditingController nameController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool wait = false;

  @override
  void initState() {
    nameController.text = widget.name;
    infoController.text = widget.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yangilik ${widget.title}'),
        backgroundColor: AppColor.blue,
      ),
      body: wait
          ? LoadingWidget(isLoading: wait)
          : SingleChildScrollView(
              child: Column(
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
                                    height: kToolbarHeight * 3,
                                    width: kToolbarHeight * 3,
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
                                    height: kToolbarHeight * 3,
                                    width: kToolbarHeight * 3,
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
                        hintText: 'Juma ayyom',
                        label: Text('Yangilik nomi'),
                        enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: infoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'juma ayyomiz muborak bulsin',
                        label: Text('Information'),
                        enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
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
                            "info": infoController.text,
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
                                  _imageFile!, 'admin/news/add', data);
                              checkResponse(context, response);
                            }
                          } else if (widget.title == 'tahrirlash') {
                            if (_imageFile != null) {
                              response = await repository.addCategory(
                                  _imageFile!, 'admin/news/update', data);
                              checkResponse(context, response);
                            } else {
                              response = await repository.addNewsString(data);
                              checkResponse(context, response);
                            }
                          }
                        }
                      },
                      buttonName: widget.title),
                ],
              ),
            ),
    );
  }

  void checkResponse(BuildContext context, HttpResult response) async {
    setState(() {
      wait = false;
    });
    await newsPaperBloc.newsPaperInfo();
    if (response.isSuccess) {
      CenterDialog.messageDialog(
          context,
          widget.id == 0 ? 'Qoshildi' : 'Tahrirlandi',
          () => Navigator.pop(context));
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
