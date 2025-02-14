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
}