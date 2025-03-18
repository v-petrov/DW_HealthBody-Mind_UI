import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime selectedDateState = DateTime.now();
  String? currentPageState;

  DateTime get selectedDate => selectedDateState;
  String? get currentPage => currentPageState;

  void updateDate(BuildContext context, DateTime newDate, String page) {
    DateTime currentDateOnly = DateTime(selectedDateState.year, selectedDateState.month, selectedDateState.day);
    DateTime newDateOnly = DateTime(newDate.year, newDate.month, newDate.day);

    if (currentDateOnly != newDateOnly || currentPageState != page) {
      selectedDateState = newDateOnly;
      currentPageState = page;
      notifyListeners();
    }
  }
}