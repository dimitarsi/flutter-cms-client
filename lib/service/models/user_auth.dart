
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth.g.dart';

@JsonSerializable()
class UserCredentials {
  UserCredentials({required this.email, required this.password});
  String email;
  String password;

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);
}

@JsonSerializable()
class LoginResponse {
  LoginResponse({this.token = "", this.error});

  @JsonKey(name: "accessToken", defaultValue: "")
  String? token;
  String? error;

  bool get hasError => error != null;

  bool get isLoggedIn => (token ?? "").isNotEmpty;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

class LoginFormController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  UserCredentials getUserCredentials() {
    print("Credentials ${email.text} | ${password.text}");
    return UserCredentials(email: email.text, password: password.text);
  }
}
