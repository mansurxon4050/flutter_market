import 'dart:convert';

import 'package:market/model/person/news_paper_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/http_result.dart';

class NewsPaperBloc {
  final Repository repository = Repository();
  final _fetchNewsPapers = PublishSubject<NewsPaperModel>();

  Stream<NewsPaperModel> get getItemInfoProducts => _fetchNewsPapers.stream;

  NewsPaperModel newsPaperModel = NewsPaperModel.fromJson({});

  newsPaperInfo() async {
    HttpResult response = await repository.getNewsPaper();
    if (response.isSuccess) {
      NewsPaperModel data = newsPaperModelModelFromJson(
        json.encode(response.result),
      );
      // if (page == 1) {
      //   itemProductData = ItemProductModel.fromJson({});
      // }
      newsPaperModel.data = [];
      newsPaperModel.data.addAll(data.data);
      _fetchNewsPapers.sink.add(newsPaperModel);
    }
  }
}

final newsPaperBloc = NewsPaperBloc();
