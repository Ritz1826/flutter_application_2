import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/pagination_model.dart';
import 'package:flutter_application_2/ui/data_model/userImages_data_model.dart';
import 'package:flutter_application_2/ui/web_service/userImages_apiHelper.dart';

class UserImagesVm extends ChangeNotifier {
  List<UserImageData>? _userImagesData;
  List<UserImageData>? get userImagesData => _userImagesData;
  set userImagesData(List<UserImageData> value) {
    _userImagesData = value;
    notifyListeners();
  }

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;
  set isInitialLoading(bool value) {
    _isInitialLoading = value;
    notifyListeners();
  }

  bool _isPaginatedLoading = false;
  bool get isPaginatedLoading => _isPaginatedLoading;
  set isPaginatedLoading(bool value) {
    _isPaginatedLoading = value;
    notifyListeners();
  }

  int page = 1;
  bool hasNextPage = true;
  String query = "";

  Future<void> getAndSetUserImages({
    bool isRefresh = false,
    String? query1,
    bool isSearching = false,
  }) async {
    try {
      //to facilitate query to be passed during pagination even when not passed
      query = query1 ?? query;

      if (isRefresh) {
        page = 1;
        userImagesData = [];
        hasNextPage = true;
        query = "";
      }

      if (isSearching) {
        page = 1;
        hasNextPage = true;
        isInitialLoading = true;
      }

      //to facilitate continuation even after no data state
      if (isPaginatedLoading || (!hasNextPage)) {
        print("i came here");
        return;
      }

      if (page > 1) {
        isPaginatedLoading = true;
      }

      print("i am here $page $query");

      PaginationModel2 result = await UserimagesApihelper().getUserImages(
        query: query,
        page: page,
      );

      hasNextPage = result.hasNextPage;

      //during search no addition in first one
      if (page == 1) {
        userImagesData = result.userData as List<UserImageData>;
      } else {
        userImagesData = [...(userImagesData ?? []), ...result.userData];
      }

      page++;
    } catch (e) {
      print(e);
    } finally {
      isInitialLoading = false;
      isPaginatedLoading = false;
    }
  }
}
