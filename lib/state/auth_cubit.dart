import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:plenty_cms/service/models/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/client/client.dart';

class AuthState {
  AuthState(
      {this.isLoggedIn = false,
      this.firstName,
      this.lastName,
      this.loginError});

  bool isLoggedIn;
  String? firstName;
  String? lastName;

  String? loginError;
}

const timeout = Duration(seconds: 5);
const lockTimeout = Duration(seconds: 1);

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthState initialState, {required this.restClient})
      : super(initialState);

  RestClient restClient;

  Timer? timer;

  bool loginLock = false;

  void login(UserCredentials credentials) async {
    var storage = await SharedPreferences.getInstance();

    if (loginLock) {
      return;
    }

    if (timer != null) {
      timer!.cancel();
      timer = null;
    }

    try {
      loginLock = true;
      var data = await restClient.tryLogin(credentials);
      var token = data.token ?? "";

      if (!data.isLoggedIn) {
        emit(AuthState(
            isLoggedIn: data.isLoggedIn,
            loginError: "Invalid credentials. Please Try Again"));

        timer = Timer(timeout, () => emit(AuthState()));
      } else if (token.isNotEmpty) {
        restClient.token = token;
        emit(AuthState(isLoggedIn: data.isLoggedIn));
        storage.setString("authToken", token);
      }
    } catch (e) {
      emit(
          AuthState(loginError: "Ups, something went wrong. Try again later!"));
      Timer(timeout, () => emit(AuthState()));
    } finally {
      Timer(lockTimeout, () => loginLock = false);
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

  void logout() async {
    var storage = await SharedPreferences.getInstance();
    storage.remove("authToken");
    emit(AuthState());
  }

  void userHasValidToken() {
    emit(AuthState(isLoggedIn: true));
  }
}
