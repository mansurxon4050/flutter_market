import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../color/color.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Column(
        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5),
              itemCount: 21,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (_, index) {
                return Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                  ),

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
