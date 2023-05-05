import 'package:flutter/material.dart';

import '../validation/is_email.dart';
import '../validation/is_not_empty.dart';

class RegistrationField {
  RegistrationField(
      {required this.label, required this.validator, required this.controller});

  String label;
  String? Function(String?) validator;
  TextEditingController controller;
}

class RegistrationFormModel {
  RegistrationFormModel() {
    fields = [
      RegistrationField(
          label: "First Name", controller: firstName, validator: isNotEmpty),
      RegistrationField(
          label: "Last Name", controller: lastName, validator: isNotEmpty),
      RegistrationField(
          label: "Email", controller: regEmail, validator: isEmailValidator)
    ];
  }
  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController regEmail = TextEditingController();

  TextEditingController regPassword = TextEditingController();

  TextEditingController gender = TextEditingController();

  late final Iterable<RegistrationField> fields;
}
