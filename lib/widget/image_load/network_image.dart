import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../color/color.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {Key? key,
      required this.imageUrl,
      required this.height,
      required this.weight})
      : super(key: key);

  final String imageUrl;
  final double height;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: 'http://mansurer.beget.tech//storage/$imageUrl',
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: AppColor.blue100,
            ),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(
              Icons.error,
              color: Colors.black,
            ),
          ),
          height: height,
          width: weight,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
