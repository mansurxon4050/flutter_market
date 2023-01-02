// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/widget/button/submit_button.dart';
import 'package:market/widget/loading/loading_widget.dart';

import '../../../api/repository.dart';
import '../../../bloc/home_star_bloc/star_product_bloc.dart';
import '../../../color/color.dart';
import '../../../model/http_result.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';
import '../../../widget/image_load/network_image.dart';

class BannerAdd extends StatefulWidget {
  const BannerAdd({
    Key? key,
    required this.id,
    required this.title,
    required this.image,
  }) : super(key: key);

  final int id;
  final String title;
  final String image;

  @override
  State<BannerAdd> createState() => _BannerAddState();
}

class _BannerAddState extends State<BannerAdd> {
  Repository repository = Repository();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reklama ${widget.title}'),
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
                          setState(() {

                          });
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
                      child:Stack(
                        children: [
                          _imageFile == null
                              ? Container(
                            height: kToolbarHeight *3,
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
                const Spacer(),
                SubmitButton(
                    onTap: () async {
                      setState(() {
                        wait = true;
                      });
                      HttpResult response;
                      var data = {
                        "id": widget.id,
                        "name": '',
                        "info": '',
                      };
                      if (widget.title == 'qoshish') {
                        if (_imageFile == null) {
                          shows();
                        } else {
                          response = await repository.addCategory(
                              _imageFile!, 'admin/banner/add', data);
                          checkResponse(context, response);
                        }
                      } else if (widget.title == 'tahrirlash') {
                        if (_imageFile != null) {
                          response = await repository.addCategory(
                              _imageFile!, 'admin/banner/update', data);

                          checkResponse(context, response);
                        } else {
                          shows();
                        }
                      }
                    },
                    buttonName: widget.title),
              ],
            ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> shows() {
    return ScaffoldMessenger.of(context).showSnackBar(
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
  }

  void checkResponse(BuildContext context, HttpResult response) async {
    if (response.isSuccess) {
      setState(() {
        wait = false;
      });
      CenterDialog.messageDialog(
          context,
          widget.id == 0 ? 'Qoshildi' : 'Tahrirlandi',
          () => Navigator.pop(context));
      await starProductBloc.allBanners();
    } else {
      setState(() {
        wait = false;
      });
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
