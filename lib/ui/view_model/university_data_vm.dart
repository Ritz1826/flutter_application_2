import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/web_service/universityData_apiHelper.dart';

class UniversityDataVm extends ChangeNotifier {
  Future<void> getAndSetUniversityData() async {
    try {
      await UniversitydataApihelper().getUniversityData(10);
    } catch (e) {
      print(e);
    }
  }
}
