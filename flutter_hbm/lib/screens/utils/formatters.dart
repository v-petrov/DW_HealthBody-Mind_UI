import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalTextInputFormatter({this.decimalPlaces = 1});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final regExp = RegExp('^\\d{0,3}(\\.\\d{0,$decimalPlaces})?\$');

    if (regExp.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class HeightTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final regExp = RegExp(r'^\d{0,3}$');

    if (regExp.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class DateFormatter {
  static String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}