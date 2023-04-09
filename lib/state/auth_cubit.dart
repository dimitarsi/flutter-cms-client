import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AuthState {
  AuthState(
      {this.isLoggedIn = false, this.token, this.firstName, this.lastName});

  bool isLoggedIn;
  String? token;
  String? firstName;
  String? lastName;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthState initialState) : super(initialState);

  void login(String email, String password) async {
    // String body = "{\"email\": \"$email\",\"password\":\"$password\"}";
    var data;
    try {
      // var data = await post(Uri.parse("http://localhost:8000/login"),
      //     body: json.encode({"email": email, "password": password}).toString(),
      //     headers: {"content-type": "application/json"});

      data = await post(Uri.parse("http://localhost:8000/login"),
          body: {"email": email, "password": password});

      if (data.statusCode < 300) {
        print(data);
        emit(AuthState(isLoggedIn: true));
      }
    } catch (e) {
      print([data, e.toString()]);
    }
  }

  void register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String gender,
      Function? onSuccess,
      Function? onError}) async {
    try {
      var data = await post(Uri.parse("http://localhost:8000/users"), body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "gender": gender
      });
      onSuccess?.call();
    } catch (e) {
      print(e);
      onError?.call();
    }
  }

  void resetPassword(String email) {
    print("Email $email");
  }

  void logout() => emit(AuthState());
}
