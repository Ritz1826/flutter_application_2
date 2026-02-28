import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/user_data_model.dart';

class UserFormVm extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void clearControllers() {
    nameController.clear();
    dobController.clear();
    countryController.clear();
  }

  String? _userName;
  String? get userName => _userName;
  set userName(String? value) {
    _userName = value;
    notifyListeners();
  }

  bool _isNameValid = false;
  bool get isNameValid => _isNameValid;
  set isNameValid(bool value) {
    _isNameValid = value;
  }

  String? _userDob;
  String? get userDob => _userDob;
  set userDob(String? value) {
    _userDob = value;
    notifyListeners();
  }

  bool _isDobValid = false;
  bool get isDobValid => _isDobValid;
  set isDobValid(bool value) {
    _isDobValid = value;
  }

  String? _userGender;
  String? get userGender => _userGender;
  set userGender(String? value) {
    _userGender = value;
    notifyListeners();
  }

  double? _userHeight;
  double? get userHeight => _userHeight;
  set userHeight(double? value) {
    _userHeight = value;
    notifyListeners();
  }

  List<String>? _userHobbies = [];
  List<String>? get userHobbies => _userHobbies;
  set addUserHobbies(String value) {
    _userHobbies = [...?userHobbies, value];
    notifyListeners();
  }

  set removeUserHobbies(String value) {
    _userHobbies = _userHobbies?.where((e) => e != value).toList();

    notifyListeners();
  }

  void removeAllHobbies() {
    _userHobbies = [];
    notifyListeners();
  }

  String? _userCountry;
  String? get userCountry => _userCountry;
  set userCountry(String? value) {
    _userCountry = value;
    notifyListeners();
  }

  UserDataModel? _userData;
  UserDataModel? get userData => _userData;
  set userData(UserDataModel? vaue) {
    _userData = vaue;
    notifyListeners();
  }

  void setUserData() {
    userData = UserDataModel(
      userCountry: userCountry,
      userDob: userDob,
      userGender: userGender,
      userHeight: userHeight,
      userHobbies: userHobbies,
      userName: userName,
    );

    print("country" + (userData?.userCountry.toString() ?? ""));
    print("dob" + (userData?.userDob.toString() ?? ""));
    print("gender" + (userData?.userGender.toString() ?? ""));
    print("height" + (userData?.userHeight.toString() ?? ""));
    print("hobbies" + (userData?.userHobbies.toString() ?? ""));
    print("usnername" + (userData?.userName.toString() ?? ""));
  }

  void clearData() {
    userCountry = null;
    userData = null;
    userDob = null;
    userGender = null;
    userHeight = null;
    removeAllHobbies();
    clearControllers();
    userName = null;
  }

  VoidCallback? validateAndContinue(
    int stepPage,
    VoidCallback? onStepContinue,
  ) {
    if (stepPage == 0 && !isNameValid) {
      return null;
    } else if (stepPage == 1 && !isDobValid) {
      return null;
    } else if (stepPage == 2 && userGender == null) {
      return null;
    } else if (stepPage == 3 && (userHeight == null || userHeight == 0)) {
      return null;
    } else if (stepPage == 4 && (userHobbies?.isEmpty ?? true)) {
      return null;
    } else if (stepPage == 5 && userCountry == null) {
      return null;
    } else {
      return onStepContinue;
    }
  }
}
