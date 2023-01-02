// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/api/repository.dart';
import 'package:market/model/http_result.dart';
import 'package:market/widget/image_load/network_image.dart';
import 'package:market/widget/loading/loading_widget.dart';

import '../../../bloc/product_bloc/product_item_bloc.dart';
import '../../../color/color.dart';
import '../../../utils/utils.dart';
import '../../../widget/dialog/center_dialog.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen(
      {Key? key,
      required this.id,
      required this.name,
      required this.info,
      required this.desc,
      required this.cat,
      required this.type,
      required this.star,
      required this.price,
      required this.discount,
      required this.disPrice,
      required this.count,
      required this.image,
      required this.title})
      : super(key: key);

  final String title, name, info, desc, cat, type, image;
  final int id, star, price, discount, disPrice, count;

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  Repository repository = Repository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _catController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _starController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _countController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool wait = false;
  String image = '', title = '';
  int id = 0;

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  void getProduct() {
    id = widget.id;
    title = widget.title;
    _nameController.text = widget.name;
    _infoController.text = widget.info;
    _descController.text = widget.desc;
    _catController.text = widget.cat;
    _typeController.text = widget.type;
    _priceController.text = widget.price.toString();
    _discountController.text = widget.discount.toString();
    _starController.text = widget.star.toString();
    _discountPriceController.text = widget.disPrice.toString();
    _countController.text = widget.count.toString();
    image = widget.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id == 0 ? "Mahsulot qoshish" : 'Mahsulotni tahrirlash'),
        backgroundColor: AppColor.blue,
      ),
      body: wait
          ? LoadingWidget(isLoading: wait)
          : Form(
              key: _formKey,
              child: ListView(
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
                                    height: kToolbarHeight * 1.5,
                                    width: kToolbarHeight * 1.5,
                                    margin: const EdgeInsets.only(
                                        top: kToolbarHeight * 0.2,
                                        bottom: kToolbarHeight * 0.2),
                                    decoration: BoxDecoration(
                                      color: AppColor.blue10,
                                      borderRadius: BorderRadius.circular(
                                          kToolbarHeight * 0.2),
                                    ),
                                    child: CustomNetworkImage(
                                      imageUrl: image,
                                      weight: kToolbarHeight,
                                      height: kToolbarHeight,
                                    ),
                                  )
                                : Container(
                                    height: kToolbarHeight * 1.5,
                                    width: kToolbarHeight * 1.5,
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
                  buildFormField('mahsulot nomi', 'Pepsi', _nameController,
                      TextInputType.name),
                  buildFormField(
                      'info', '1.5 litr', _infoController, TextInputType.name),
                  buildFormField('mahsulot haqida malumot', 'Pepsi',
                      _descController, TextInputType.name),
                  buildFormField('kategoriyasi', 'Ichimliklar', _catController,
                      TextInputType.name),
                  buildFormField(
                      'turi', 'dona,kg', _typeController, TextInputType.name),
                  buildFormField('yulduzlar soni', '123', _starController,
                      TextInputType.number),
                  buildFormField('narxi', '11 000 ', _priceController,
                      TextInputType.number),
                  buildFormField('chegirma', '20', _discountController,
                      TextInputType.number),
                  buildFormField('chegirma narxi', '10 000',
                      _discountPriceController, TextInputType.number),
                  buildFormField('mahsulot Umumiy soni', '100',
                      _countController, TextInputType.number),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: kToolbarHeight,
                        vertical: kToolbarHeight * 0.2),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              wait = true;
                            });
                            HttpResult response;
                            var data = {
                              "id": id,
                              "name": _nameController.text,
                              "star": int.parse(_starController.text),
                              "info": _infoController.text,
                              "description": _descController.text,
                              "category": _catController.text,
                              "type": _typeController.text,
                              "price": int.parse(_priceController.text),
                              "discount": int.parse(_discountController.text),
                              "discount_price":
                                  int.parse(_discountPriceController.text),
                              "count": int.parse(_countController.text)
                            };
                            if (title == 'add') {
                              if (_imageFile != null) {
                                response = await repository.addProduct(
                                    _imageFile!, "admin/product/create", data);
                                checkDialogAndShow(context, response);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Rasmni kiriting",
                                        style: TextStyle(
                                            fontSize: kToolbarHeight * 0.28,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } else if (title == 'update' &&
                                _imageFile != null) {
                              response = await repository.addProduct(
                                  _imageFile!, "admin/product/update", data);
                              checkDialogAndShow(context, response);
                            } else if (title == 'update' &&
                                _imageFile == null) {
                              response =
                                  await repository.addProductString(data);
                              checkDialogAndShow(context, response);
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Mahsulotni qoshish"),
                        )),
                  )
                ],
              )),
    );
  }

  buildFormField(String label, String hint, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'kiriting';
          }
          return null;
        },
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(),
          errorBorder: const OutlineInputBorder(),
          disabledBorder: const OutlineInputBorder(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  void checkDialogAndShow(BuildContext context, HttpResult response) async {
    if (response.isSuccess) {
      setState(() {
        wait = false;
      });
      CenterDialog.messageDialog(context, id == 0 ? 'Qoshildi' : 'Tahrirlandi',
          () => Navigator.pop(context));
      await productItemBloc.allProductInfo(1);
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
