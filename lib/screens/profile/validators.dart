class Validators {
  static String? requiredText(String? v, {int max = 50}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Required';
    if (s.length > max) return 'Too long';
    return null;
  }

  static String? optionalShort(String? v, {int max = 40}) {
    final s = (v ?? '').trim();
    if (s.length > max) return 'Too long';
    return null;
  }

  static String? plate(String? v) {
    final s = (v ?? '').trim().toUpperCase();
    if (s.isEmpty) return 'Required';
    final re = RegExp(r'^[A-Z0-9]{1,8}$');
    if (!re.hasMatch(s)) return 'Use 1–8 letters/digits';
    return null;
  }
}
