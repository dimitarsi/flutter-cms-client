import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';
import 'package:plenty_cms/views/auth/forms/register.dart';

import 'forms/login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, this.resetToken});

  String? resetToken;

  @override
  State<LoginPage> createState() => _LoginPageState(resetToken: resetToken);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController resetPasswordController = TextEditingController();

  late final PageController pageViewController;

  String? resetToken;

  String? errorMessage;

  _LoginPageState({this.resetToken}) : super();

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
          builder: (context, state) => page(context, state.isLoggedIn),
        ));
  }

  page(BuildContext context, bool isLoggedIn) {
    if (resetToken != null) {
      return resetPassword(context);
    }

    return isLoggedIn
        ? logout(context)
        : Container(
            child: pageView(context),
          );
  }

  PageView pageView(BuildContext context) {
    return PageView(
      controller: pageViewController,
      children: [
        LoginForm(
          pageViewController: pageViewController,
        ),
        RegisterForm(
          pageViewController: pageViewController,
        ),
        forgottenPassword(context)
      ],
    );
  }

  Center forgottenPassword(BuildContext context) {
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

  Column logout(BuildContext context) {
    return Column(
      children: [
        const Text("You are logged in"),
        TextButton(
            onPressed: context.read<AuthCubit>().logout,
            child: const Text("Log out"))
      ],
    );
  }

  Center resetPassword(BuildContext context) {
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
