import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/auth_cubit.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key, required this.pageViewController});

  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController regEmail = TextEditingController();

  TextEditingController regPassword = TextEditingController();

  TextEditingController gender = TextEditingController();

  final PageController pageViewController;

  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
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
        Container(height: 10),
        DropdownMenu(
          width: 300,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
                onPressed: () => pageViewController.jumpTo(0),
                child: const Text("Login"))
          ],
        ),
      ],
    );
  }
}
