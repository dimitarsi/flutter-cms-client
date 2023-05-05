String? isPasswordValidator(String? val) {
  if (val == null || val.length < 8) {
    return "Password needs to be at least 8 characters long";
  }

  return null;
}
