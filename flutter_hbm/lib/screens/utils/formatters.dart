import 'package:flutter/services.dart';

class WaterTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  WaterTextInputFormatter({this.decimalPlaces = 1});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final regExp = RegExp('^\\d{0,2}(\\.\\d{0,$decimalPlaces})?\$');

    if (regExp.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

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

class IntegerTextInputFormatter extends TextInputFormatter {
  int? num;
  IntegerTextInputFormatter(int this.num);
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final regExp = RegExp(r'^(0|[1-9]\d{0,' + (num! - 1).toString() + r'})$');

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