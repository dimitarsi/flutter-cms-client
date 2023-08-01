import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/models/user_auth.dart';
import 'package:plenty_cms/widgets/login/forms/validation/is_email.dart';
import 'package:plenty_cms/widgets/login/forms/validation/is_password.dart';

import '../../../state/auth_cubit.dart';

class LoginFormView extends StatelessWidget {
  const LoginFormView(
      {super.key,
      this.pageViewController,
      this.loginError,
      required this.form,
      required this.loginFormKey});

  final PageController? pageViewController;

  final String? loginError;

  final LoginFormController form;
  final GlobalKey<FormState> loginFormKey;

  @override
  Widget build(BuildContext context) {
    var loginErrorMessage = loginError ?? "";

    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: form.email,
              validator: isEmailValidator,
              decoration: const InputDecoration(labelText: "Email"),
              onEditingComplete: () => _submit(context),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: form.password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              validator: isPasswordValidator,
              onEditingComplete: () {
                _submit(context);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
                onPressed: () => _submit(context),
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
                const Text("Trouble logging in?"),
                TextButton(
                    onPressed: () => pageViewController?.jumpToPage(2),
                    child: const Text("Forgotten password"))
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
              child: const Text("Create an account")),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    if (loginFormKey.currentState != null) {
      var formState = loginFormKey.currentState;

      if (formState != null && formState.validate()) {
        context.read<AuthCubit>().login(form.getUserCredentials());
      }
    }
  }
}
