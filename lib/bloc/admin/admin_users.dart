
import 'dart:convert';

import 'package:market/model/admin/users_model.dart';
import 'package:market/model/home/home_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/http_result.dart';

class AllUsersBloc {

  final Repository _repository = Repository();
  final _fetchUsers = PublishSubject<AllUsersModel>();

  Stream<AllUsersModel> get getAllUsers => _fetchUsers.stream;


  AllUsersModel usersModel = AllUsersModel.fromJson({});

  allUsersFunction(int page) async {
    HttpResult response = await _repository.allUsers(page);
    if (response.isSuccess) {
      AllUsersModel data = allUsersModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        usersModel = AllUsersModel.fromJson({});
      }
      usersModel.data.addAll(data.data);
      usersModel.links = data.links;
      usersModel.meta = data.meta;
      _fetchUsers.sink.add(usersModel);
    }
  }
  allUsersSearch(int page,String search) async {
    HttpResult response = await _repository.allUsersSearch(page,search);
    if (response.isSuccess) {
      AllUsersModel data = allUsersModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        usersModel = AllUsersModel.fromJson({});
      }
      usersModel.data.addAll(data.data);
      usersModel.links = data.links;
      usersModel.meta = data.meta;
      _fetchUsers.sink.add(usersModel);
    }
  }
  maxMonthPrice(int page,String search) async {
    HttpResult response = await _repository.allMaxMonthPrice(page,search);
    if (response.isSuccess) {
      AllUsersModel data = allUsersModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        usersModel = AllUsersModel.fromJson({});
      }
      usersModel.data.addAll(data.data);
      usersModel.links = data.links;
      usersModel.meta = data.meta;
      _fetchUsers.sink.add(usersModel);
    }
  }
}

final allUsersBloc = AllUsersBloc();
