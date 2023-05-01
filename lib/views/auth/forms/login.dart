import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/models/user_auth.dart';

import '../../../state/auth_cubit.dart';

class LoginFormView extends StatelessWidget {
  LoginFormView(
      {super.key,
      this.pageViewController,
      this.loginError,
      required this.form,
      required this.loginFormKey});

  final PageController? pageViewController;

  String? loginError;

  LoginFormController form;
  GlobalKey<FormState> loginFormKey;

  @override
  Widget build(BuildContext context) {
    var loginErrorMessage = loginError ?? "";

    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          FormField(
            builder: (context) => SizedBox(
              width: 300,
              child: TextFormField(
                controller: form.email,
                validator: (value) {
                  var isEmail = RegExp(r'\w@\w').allMatches(value ?? "");
                  if (isEmail.isEmpty) {
                    return "Invalid email address";
                  }
                },
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ),
          ),
          FormField(
            builder: (context) => SizedBox(
              width: 300,
              child: TextFormField(
                controller: form.password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (val) {
                  if (val != null && val.length < 8) {
                    return "Password needs to be at least 8 characters long";
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  if (loginFormKey.currentState != null) {
                    var formState = loginFormKey.currentState;

                    if (formState != null && formState.validate()) {
                      context
                          .read<AuthCubit>()
                          .login(form.getUserCredentials());
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("Submit"),
                )),
          ),
          if (loginErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                loginErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
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
              child: Text("Create an account")),
        ],
      ),
    );
  }
}
