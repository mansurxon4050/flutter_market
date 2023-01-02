

import '../model/http_result.dart';

class Utils {
  static String serverErrorText(HttpResult response) {
    String s = "Server bilan bo'liq xatolik";
    if (response.status == 500 || response.status == 404) {
      return response.status.toString();
    } else {
      try {
        return response.result["message"] ?? s;
      } catch (_) {
        return s;
      }
    }
  }

}
