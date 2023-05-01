import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/service/models/user_auth.dart';
import 'package:plenty_cms/state/auth_cubit.dart';
import 'package:plenty_cms/screens/auth/forms/register.dart';

import 'forms/login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, this.resetToken});

  final String? resetToken;
  final LoginFormController form = LoginFormController();
  final GlobalKey<FormState> loginFormKey =
      GlobalKey(debugLabel: "Login Form Key");

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController resetPasswordController = TextEditingController();

  late final PageController pageViewController;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    pageViewController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideNav(),
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: page,
        ));
  }

  Widget page(BuildContext context, AuthState state) {
    if (widget.resetToken != null) {
      return resetPassword();
    }

    var isLoggedIn = state.isLoggedIn;
    var errorMessage = state.loginError ?? "";

    return isLoggedIn
        ? logout()
        : Container(
            child: pageView(context, errorMessage: errorMessage),
          );
  }

  PageView pageView(BuildContext context, {required String errorMessage}) {
    return PageView(
      controller: pageViewController,
      children: [
        LoginFormView(
          pageViewController: pageViewController,
          loginError: errorMessage,
          form: widget.form,
          loginFormKey: widget.loginFormKey,
        ),
        RegisterForm(
          pageViewController: pageViewController,
        ),
        forgottenPassword()
      ],
    );
  }

  Center forgottenPassword() {
    double maxWidth = min(MediaQuery.of(context).size.width, 400);

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(
          children: [
            const Text("You will receive an email with a reset link"),
            TextField(
              controller: resetPasswordController,
            ),
            Container(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => pageViewController.jumpToPage(0),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.arrow_back,
                            size: 15,
                          ),
                        ),
                        Text("Back"),
                      ],
                    )),
                OutlinedButton(
                    onPressed: () {
                      context
                          .read<AuthCubit>()
                          .resetPassword(resetPasswordController.text);
                      pageViewController.jumpToPage(0);
                    },
                    child: const Text("Send")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget logout() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 8),
            child: Text("You are logged in"),
          ),
          TextButton(
              onPressed: context.read<AuthCubit>().logout,
              child: const Text("Log out"))
        ],
      ),
    );
  }

  Center resetPassword() {
    double maxWidth = min(MediaQuery.of(context).size.width, 400);

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(children: [
          Container(height: 20),
          const Text(
            "Reset Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Container(height: 20),
          const TextField(
            decoration: InputDecoration(hintText: "Password"),
            obscureText: true,
          ),
          const TextField(
            decoration: InputDecoration(hintText: "Repeat Password"),
            obscureText: true,
          ),
          Container(
            height: 40,
          ),
          OutlinedButton(
              onPressed: () {
                context.goNamed('login');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text("Submit"),
              ))
        ]),
      ),
    );
  }
}
