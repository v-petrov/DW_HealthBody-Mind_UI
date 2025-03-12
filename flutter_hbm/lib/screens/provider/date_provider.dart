import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime selectedDateState = DateTime.now();
  String? currentPageState;

  DateTime get selectedDate => selectedDateState;
  String? get currentPage => currentPageState;

  void updateDate(BuildContext context, DateTime newDate, String page) {
    if (selectedDateState != newDate || currentPageState != page) {
      selectedDateState = newDate;
      currentPageState = page;
      notifyListeners();
    }
  }
}