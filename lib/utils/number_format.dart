import 'package:flutter_translate/flutter_translate.dart';

class NumberType {
  static String numberPrice(String price) {
    String newPrice = '';
    int k = 1;
    for (int i = price.length - 1; i >= 0; i--) {
      if (k % 3 == 0) {
        newPrice = ' ${price[i]}$newPrice';
      } else {
        newPrice = '${price[i]}$newPrice';
      }
      k++;
    }
    return '$newPrice ${translate('sum')}';
  }
}
