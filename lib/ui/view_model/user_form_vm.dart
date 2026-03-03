import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/user_data_model.dart';
import 'package:flutter_application_2/ui/form_widgets/widget_helpers/dob_helpers.dart';

class UserFormVm extends ChangeNotifier {
  ///tbd
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

  String? _userDob;
  String? get userDob => _userDob;
  set userDob(String? value) {
    _userDob = value;
    notifyListeners();
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
    _userCountry = null;
    _userData = null;
    _userDob = null;
    _userGender = null;
    _userHeight = null;
    removeAllHobbies();
    clearControllers();
    _userName = null;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    print("vm set $value");
    _isLoading = value;
    notifyListeners();
  }

  void validateAndContinue(
    int stepPage,
    GlobalKey<FormState> formKey, {
    Function()? shouldProceed,
    Function(dynamic e)? onError,
  }) async {
    ///todo - switch
    if (stepPage == 1) {
      getGenderState(stepPage + 1);
    }

    if (stepPage == 2) {
      getHeightState(stepPage + 1);
    }

    if (stepPage == 3) {
      getHobbiesState(stepPage + 1);
    }

    if (stepPage == 4) {
      getCountryState(stepPage + 1);
    }

    if (stepPage == 5) {
      try {
        bool x = await shouldProceed!();

        if (x) {
          print("am i hereeeee");
          isLoading = true;

          await Future.delayed(Duration(seconds: 10));

          setUserData();
          formKey.currentState?.reset();

          clearData();

          isLoading = false;
        } else {
          print("or am i hereeeee");
          throw Exception("failed");
        }
      } catch (e) {
        print("rintu ${e.toString()}");
        onError?.call(e);
      }
    }
  }

  bool tapAndValidate(stepPage) {
    if (stepPage == 0 && !isNameValidator(nameController.text)) {
      return false;
    } else if (stepPage == 1 && !isDobValidator(dobController.text)) {
      return false;
    } else if (stepPage == 2 && userGender == null) {
      return false;
    } else if (stepPage == 3 && (userHeight == null || userHeight == 0)) {
      return false;
    } else if (stepPage == 4 && (userHobbies?.isEmpty ?? true)) {
      return false;
    } else if (stepPage == 5 && userCountry == null) {
      return false;
    } else {
      return true;
    }
  }

  StepState _nameState = StepState.indexed;
  StepState get nameState => _nameState;
  set nameState(StepState value) {
    _nameState = value;
    notifyListeners();
  }

  StepState _dobState = StepState.indexed;
  StepState get dobState => _dobState;
  set dobState(StepState value) {
    _dobState = value;
    notifyListeners();
  }

  StepState _genderState = StepState.indexed;
  StepState get genderState => _genderState;
  set genderState(StepState value) {
    _genderState = value;
    notifyListeners();
  }

  StepState _heightState = StepState.indexed;
  StepState get heightState => _heightState;
  set heightState(StepState value) {
    _heightState = value;
    notifyListeners();
  }

  StepState _hobbiesState = StepState.indexed;
  StepState get hobbiesState => _hobbiesState;
  set hobbiesState(StepState value) {
    _hobbiesState = value;
    notifyListeners();
  }

  StepState _countryState = StepState.indexed;
  StepState get countryState => _countryState;
  set countryState(StepState value) {
    _countryState = value;
    notifyListeners();
  }

  void getNameState(int stepPage, String? value) {
    if (stepPage == 0 && userName == null) {
      nameState = StepState.editing;
      return;
    }

    if (stepPage == 0 && !isNameValidator(value)) {
      nameState = StepState.error;
      return;
    } else if (isNameValidator(value)) {
      nameState = StepState.complete;
    } else {
      nameState = StepState.indexed;
    }
  }

  void getDobState(int stepPage, String? value) {
    if (stepPage == 1 && userDob == null) {
      dobState = StepState.editing;
    } else if (stepPage == 1 && !isDobValidator(value)) {
      dobState = StepState.error;
    } else if (isDobValidator(value)) {
      dobState = StepState.complete;
    } else {
      dobState = StepState.indexed;
    }
  }

  void getGenderState(int stepPage) {
    if (stepPage == 2 && userGender == null) {
      genderState = StepState.editing;
    } else if (userGender != null) {
      genderState = StepState.complete;
    } else {
      genderState = StepState.indexed;
    }
  }

  void getHeightState(int stepPage) {
    if (stepPage == 3 && (userHeight == null || userHeight == 0)) {
      heightState = StepState.editing;
    } else if (userHeight != null) {
      heightState = StepState.complete;
    } else {
      heightState = StepState.indexed;
    }
  }

  void getHobbiesState(int stepPage) {
    if (stepPage == 4 && (userHobbies?.isEmpty ?? true)) {
      hobbiesState = StepState.editing;
    } else if (userHobbies?.isNotEmpty ?? true) {
      hobbiesState = StepState.complete;
    } else {
      hobbiesState = StepState.indexed;
    }
  }

  void getCountryState(int stepPage) {
    if (stepPage == 5 && userCountry == null) {
      countryState = StepState.editing;
    } else if (userCountry != null) {
      countryState = StepState.complete;
    } else {
      countryState = StepState.indexed;
    }
  }

  bool isNameValidator(String? value) {
    if ((value?.length ?? 0) <= 2) {
      return false;
    } else {
      return true;
    }
  }

  bool isDobValidator(String? value) {
    if (!DateValidator().isValidDate(value)) {
      return false;
    } else {
      return true;
    }
  }
}
