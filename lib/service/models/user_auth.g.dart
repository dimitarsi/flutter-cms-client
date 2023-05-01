// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCredentials _$UserCredentialsFromJson(Map<String, dynamic> json) =>
    UserCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserCredentialsToJson(UserCredentials instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['accessToken'] as String? ?? '',
      error: json['error'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.token,
      'error': instance.error,
    };
