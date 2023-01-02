import 'dart:convert';
import 'dart:io';

import 'package:market/model/person/favorite_model.dart';
import 'package:market/model/person/history_model.dart';
import 'package:market/service/local_notification_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/repository.dart';
import '../../main.dart';
import '../../model/http_result.dart';
import '../../noti.dart';

class HistoryProductBloc {
  final Repository repository = Repository();
  final _fetchProducts = PublishSubject<AllHistoryModel>();
  final _fetchProductss = PublishSubject<AllHistoryModel>();

  Stream<AllHistoryModel> get getAllHistoryModel => _fetchProducts.stream;
  Stream<AllHistoryModel> get getAllHistoryModels => _fetchProductss.stream;

  LocalNotificationService service = LocalNotificationService();

  AllHistoryModel allHistoryData = AllHistoryModel.fromJson({});

  allUserHistory(int userId, int page) async {
    HttpResult response = await repository.getHistoryInfo(userId, page);
    if (response.isSuccess) {
      AllHistoryModel data = allHistoryModelFromJson(
        json.encode(response.result),
      );
      allHistoryData.data = [];
      allHistoryData.data.addAll(data.data);
      _fetchProducts.sink.add(allHistoryData);
    }
  }

  allHistories(int page, String roleId) async {
    int length = allHistoryData.data.length;
    HttpResult response = await repository.getHistories(page);
    if (response.isSuccess) {
      AllHistoryModel data = allHistoryModelFromJson(
        json.encode(response.result),
      );
      allHistoryData.data = [];
      allHistoryData.data.addAll(data.data);
      _fetchProductss.sink.add(allHistoryData);
      //     print('data length ${data.data.length}  $length');

      _fetchProductss.stream.listen((event) async {
        if (roleId != "user" &&
            data.data.length > length&&allHistoryData.data[0].make=="") {
          await service.showNotificationWithPayload(
              id: 1,
              title: allHistoryData.data[0].userName,
              body: allHistoryData.data[0].totalPrice.toString(),
              payload: 'News List');
        }
      });
    }
  }
}

final historyProductBloc = HistoryProductBloc();
