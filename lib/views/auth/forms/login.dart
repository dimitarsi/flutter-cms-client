import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/auth_cubit.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key, this.pageViewController});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final PageController? pageViewController;

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          width: 300,
          child: ElevatedButton(
              onPressed: () {
                // context.read<AuthCubit>().login(email.text, password.text);
                context.read<AuthCubit>().login(email.text, password.text);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text("Submit"),
              )),
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
            child: Text("Create an account"))
      ],
    );
  }
}
