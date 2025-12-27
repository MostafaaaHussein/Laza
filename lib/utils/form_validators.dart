class FormValidators {
  static String? requiredField(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Use at least $minLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? compareTo) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (compareTo != null && value != compareTo) {
      return 'Passwords do not match';
    }
    return null;
  }
}

