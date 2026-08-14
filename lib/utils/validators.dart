/// Reusable `TextFormField` validators.
///
/// Keeping them here instead of writing closures inline means the same rules
/// apply everywhere — the phone rule on the register form is the same rule the
/// booking form uses.
///
/// Every method returns `null` when the value is valid, or an error message.
class Validators {
  Validators._();

  static String? notEmpty(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? name(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Name is required';
    if (v.length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r"^[a-zA-Z.\s']+$").hasMatch(v)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  static String? email(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    final RegExp pattern = RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Bangladeshi mobile format: 11 digits starting with 01.
  static String? phone(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(v)) {
      return 'Enter a valid 11-digit number (e.g. 01712345678)';
    }
    return null;
  }

  static String? password(String? value) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? age(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Age is required';
    final int? parsed = int.tryParse(v);
    if (parsed == null) return 'Age must be a number';
    if (parsed < 1 || parsed > 120) return 'Enter a realistic age';
    return null;
  }

  static String? problem(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Please describe the problem';
    if (v.length < 10) return 'Please add a little more detail';
    return null;
  }
}