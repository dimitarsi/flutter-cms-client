var isEmailRegex = RegExp(r'\w@\w');

String? isEmailValidator(String? val) {
  var isEmail = RegExp(r'\w@\w').allMatches(val ?? "");

  if (val == null || val.isEmpty || isEmail.isEmpty) {
    return "Invalid email address";
  }

  return null;
}
