class Validators {
  static String? validateName(String? value) {
    if  (value == null || value.trim().isEmpty) {
      return "This field is required!";
    }
    if (value.length < 2 || value.length > 50) {
      return "Length must be between 2 and 50 characters!";
    }
    final regName = RegExp(r"^(?!.*[-' ].*[-' ])[A-ZÀ-ÖØ-Ý][a-zà-öø-ÿ]*(?:[-' ][A-ZÀ-ÖØ-Ý][a-zà-öø-ÿ]*)?$");
    if (!regName.hasMatch(value)) {
      return "Names must begin with an uppercase letter,may\n"
          "contain a hyphen, an apostrophe or a space.";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required!";
    }
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegExp.hasMatch(value)) {
      return "Invalid email format!";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required!";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters!";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password!";
    }
    if (value != password) {
      return "Passwords do not match!";
    }
    return null;
  }

  static String? validateDropdownMenu(String? target, String targetString) {
    return (target == null || target.isEmpty) ? "$targetString field is required!" : null;
  }

  static String? validateBirthDate(DateTime? value) {
    return (value == null) ? "Date of birth is required!" : null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Height is required!";
    }
    final num? number = num.tryParse(value);
    if (number == null) {
      return "Height must be a valid number!";
    }
    if (number < 50 || number > 270) {
      return "Height must be between 50 and 270 cm!";
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Weight is required!";
    }
    final num? number = num.tryParse(value);
    if (number == null) {
      return "Weight must be a valid number!";
    }
    if (number < 30.0 || number > 300.0) {
      return "Weight must be between 30.0 and 300.0 kg!";
    }
    return null;
  }

  static String? validateGoalWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Goal weight is required!";
    }
    final num? number = num.tryParse(value);
    if (number == null) {
      return "Goal weight must be a valid number!";
    }
    if (number < 30.0 || number > 300.0) {
      return "Goal weight must be between 30.0 and 300.0 kg!";
    }
    return null;
  }

  static String? validateGoalWeightWithGoalAndWeight(String? weightValue, String? goalWeightValue, String? goal) {
    if (weightValue == null || goalWeightValue == null || goal == null) {
      return "Goal weight and current weight are required!";
    }

    final num? weight = num.tryParse(weightValue);
    final num? goalWeight = num.tryParse(goalWeightValue);

    if (weight == null || goalWeight == null) {
      return "Please enter a valid number!";
    }

    switch (goal) {
      case "LOSE_WEIGHT":
        if (goalWeight >= weight) return "Goal weight must be lower than current weight!";
        break;
      case "GAIN_WEIGHT":
        if (goalWeight <= weight) return "Goal weight must be higher than current weight!";
        break;
      case "MAINTAIN_WEIGHT":
        if (goalWeight != weight) return "Goal weight must be equal to current weight!";
        break;
    }
    return null;
  }

  static String? validateWeeklyGoalWithGoal(String? goal, String? weeklyGoal) {
    if (goal == null || weeklyGoal == null) {
      return "Weekly goal is required!";
    }

    if ((goal == "LOSE_WEIGHT" && (weeklyGoal == "GAIN_0_5_KG" || weeklyGoal == "GAIN_1_KG" || weeklyGoal == "MAINTAIN")) ||
        (goal == "GAIN_WEIGHT" && (weeklyGoal == "LOSE_0_5_KG" || weeklyGoal == "LOSE_1_KG" || weeklyGoal == "MAINTAIN")) ||
        (goal == "MAINTAIN_WEIGHT" && (weeklyGoal != "MAINTAIN"))) {
      return "Weekly goal must align with your main goal!";
    }

    return null;
  }
}