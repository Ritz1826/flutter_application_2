import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/pagination_model.dart';
import 'package:flutter_application_2/ui/data_model/university_data_model.dart';
import 'package:flutter_application_2/ui/web_service/universityData_apiHelper.dart';

class UniversityDataVm extends ChangeNotifier {
  List<User>? _userUniversityData;
  List<User>? get userUniversityData => _userUniversityData;
  set userUniversityData(List<User>? value) {
    _userUniversityData = value;
    notifyListeners();
  }

  bool _initialLoading = true;
  bool get initialLoading => _initialLoading;
  set initialLoading(bool value) {
    _initialLoading = value;
    notifyListeners();
  }

  bool _paginationLoading = false;
  bool get paginationLoading => _paginationLoading;
  set paginationLoading(bool value) {
    _paginationLoading = value;
    notifyListeners();
  }

  int skip = 0;
  bool hasNextPage = true;

  Future<void> getAndSetUniversityData({bool? isRefresh}) async {
    try {
      if (isRefresh ?? false) {
        skip = 0;
        userUniversityData = [];
      }

      if (paginationLoading || !hasNextPage) {
        return;
      }

      if (skip > 0) {
        paginationLoading = true;
      }

      PaginationModel<User> data = await UniversitydataApihelper()
          .getUniversityData(skip);

      userUniversityData = [...(userUniversityData ?? []), ...data.userData];

      hasNextPage = data.hasNextPage;

      skip += 20;
    } catch (e) {
      print(e);
    } finally {
      paginationLoading = false;
      initialLoading = false;
    }
  }
}
