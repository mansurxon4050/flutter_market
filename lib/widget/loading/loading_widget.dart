import 'package:flutter/material.dart';

import '../../color/color.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;

  const LoadingWidget({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: isLoading ? 1.0 : 0.0,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.blue100,
          ),
        ),
      ),
    );
  }
}
