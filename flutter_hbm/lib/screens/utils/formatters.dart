import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  int? decimalPlaces;
  int? integerPart;
  DecimalTextInputFormatter(int this.integerPart, int this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final regExp = RegExp(r'^[1-9]\d{0,' + integerPart.toString() + r'}(\.\d{0,' + decimalPlaces.toString() + r'})?$');

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