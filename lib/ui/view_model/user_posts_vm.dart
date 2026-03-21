import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/user_posts_model.dart';
import 'package:flutter_application_2/ui/web_service/api_helper.dart';
import 'package:image_picker/image_picker.dart';

class UserPostsVm extends ChangeNotifier {
  List<UsersPosts>? _allUsersPosts = [];

  List<UsersPosts>? get allUsersPosts => _allUsersPosts;

  set allUsersPosts(List<UsersPosts>? value) {
    _allUsersPosts = value;
    notifyListeners();
  }

  bool _arePostsLoading = false;
  bool get arePostsLoading => _arePostsLoading;
  set arePostsLoading(bool value) {
    _arePostsLoading = value;
    notifyListeners();
  }

  Future<void> getAndSetPosts() async {
    try {
      arePostsLoading = true;
      List<UsersPosts> result = await getPosts();
      allUsersPosts = result;
    } catch (e) {
      print(e);
    } finally {
      arePostsLoading = false;
    }
  }

  String? _userTitle;
  String? get userTitle => _userTitle;
  set userTitle(String? value) {
    _userTitle = value;
    notifyListeners();
  }

  Future<void> getAndSetTitle() async {
    try {
      arePostsLoading = true;
      await setTitle(userTitle);
    } catch (e) {
      print(e);
    } finally {
      arePostsLoading = false;
    }
  }

  XFile? _imgFile;
  XFile? get imgFile => _imgFile;
  set imgFile(XFile? value) {
    _imgFile = value;
    notifyListeners();
  }

  String? _filePath;
  String? get filePath => _filePath;
  set filePath(String? value) {
    _filePath = value;
    notifyListeners();
  }

  String? _img;
  String? get img => _img;
  set img(String? value) {
    _img = value;
    notifyListeners();
  }

  Future<void> getAndSetImg() async {
    try {
      arePostsLoading = true;
      String img1 = await postImage(imgFile, filePath);
      img = img1;
    } catch (e) {
      print(e);
    } finally {
      arePostsLoading = false;
    }
  }
}
