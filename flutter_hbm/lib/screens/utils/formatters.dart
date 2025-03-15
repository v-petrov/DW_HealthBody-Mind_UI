import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

class HoursTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final regExp = RegExp(r'^$|^(0|[1-9]|1[0-9]|2[0-3])$');

    if (regExp.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class MinutesTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final regExp = RegExp(r'^$|^(0|[1-9]|[1-5][0-9])$');

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

class ProfilePageStringFormatter {
  static String formatActivityLevel(String level) {
    switch (level) {
      case "VERY_ACTIVE":
        return "Very Active - Intense exercise 6-7 times/week";
      case "MODERATELY_ACTIVE":
        return "Moderately Active - Exercise 3-4 times/week";
      case "SEDENTARY":
        return "Sedentary - Little or no exercise";
      case "ACTIVE":
        return "Active - Intense exercise 3-4 times/week";
      case "SLIGHT_ACTIVE":
        return "Slight active - Exercise 1-3 times/week";
      default:
        return level;
    }
  }
  static String formatUserGoal(String weeklyGoal) {
    switch (weeklyGoal) {
      case "LOSE_0_5_KG":
        return "To lose 0.5kg";
      case "LOSE_1_KG":
        return "To lose 1kg";
      case "GAIN_0_5_KG":
        return "To gain 0.5kg";
      case "GAIN_1_KG":
        return "To gain 1kg";
      case "MAINTAIN":
        return "To maintain your weight";
      default:
        return weeklyGoal;
    }
  }
  static String formatGoal(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return "To lose weight";
      case "GAIN_WEIGHT":
        return "To gain weight";
      case "MAINTAIN_WEIGHT":
        return "To maintain weight";
      default:
        return goal;
    }
  }
  static String formatGender(String gender) {
    return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
  }
  static String formatDateInProfile(String stringDate) {
    DateTime date = DateTime.parse(stringDate);
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('y').format(date);

    String suffix = getDaySuffix(int.parse(day));

    return "$day$suffix of $month $year";
  }
  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}