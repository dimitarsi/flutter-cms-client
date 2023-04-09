import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, this.resetToken});

  String? resetToken;

  @override
  State<LoginPage> createState() => _LoginPageState(resetToken: resetToken);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController regEmail = TextEditingController();

  TextEditingController regPassword = TextEditingController();

  TextEditingController gender = TextEditingController();

  String selectedGender = "";

  TextEditingController resetPasswordController = TextEditingController();

  late final PageController? pageViewController;

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
      children: [login(context), register(context), forgottenPassword(context)],
    );
  }

  Center forgottenPassword(BuildContext context) {
    double maxWidth = min(MediaQuery.of(context).size.width, 400);

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(
          children: [
            Text("You will receive an email with a reset link"),
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
                    onPressed: () => pageViewController?.jumpToPage(0),
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
                      pageViewController?.jumpToPage(0);
                    },
                    child: Text("Send")),
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

  Column login(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: email,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () {
              context.read<AuthCubit>().login(email.text, password.text);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Submit"),
            )),
        Container(
          height: 80,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Trouble logging in?"),
              TextButton(
                  onPressed: () => pageViewController?.jumpToPage(2),
                  child: Text("Forgotten password"))
            ],
          ),
        ),
        const SizedBox(
          width: 300,
          child: Divider(
            color: Color.fromARGB(80, 128, 128, 128),
            height: 60,
          ),
        ),
        TextButton(
            onPressed: () => pageViewController?.jumpToPage(1),
            child: Text("Create an account"))
      ],
    );
  }

  Column register(BuildContext context) {
    var fields = [
      {"First Name", firstName},
      {"Last Name", lastName},
      {"Email", regEmail}
    ];
    return Column(
      children: [
        ...fields.map((f) => SizedBox(
              width: 300,
              child: TextField(
                controller: f.elementAt(1) as TextEditingController,
                decoration: InputDecoration(label: Text(f.first as String)),
              ),
            )),
        SizedBox(
          width: 300,
          child: TextField(
            obscureText: true,
            controller: regPassword,
            decoration: const InputDecoration(label: Text("Password")),
          ),
        ),
        DropdownMenu(
          onSelected: (value) => selectedGender = value.toString(),
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: "foobar", label: "Female"),
            DropdownMenuEntry(value: "barbaz", label: "Male"),
          ],
          hintText: "Gender",
        ),
        TextButton(
            onPressed: () {
              context.read<AuthCubit>().register(
                  firstName: firstName.text,
                  lastName: lastName.text,
                  email: regEmail.text,
                  gender: selectedGender,
                  password: regPassword.text,
                  onError: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid Form data"),
                      backgroundColor: Colors.orange,
                    ));
                  },
                  onSuccess: () => pageViewController?.jumpToPage(0));
            },
            child: const Text("Submit")),
        Container(
          height: 40,
        ),
        Row(
          children: [
            Text("Already have an account?"),
            TextButton(
                onPressed: () => pageViewController?.jumpTo(0),
                child: Text("Login"))
          ],
        ),
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
          Text(
            "Reset Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Container(height: 20),
          TextField(
            decoration: InputDecoration(hintText: "Password"),
            obscureText: true,
          ),
          TextField(
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
