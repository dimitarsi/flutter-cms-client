import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/auth_cubit.dart';
import 'models/registration_form.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm(
      {super.key, required this.pageViewController, required this.model});
  final RegistrationFormModel model;
  final PageController pageViewController;

  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...model.fields.map((f) => SizedBox(
              width: 300,
              child: TextFormField(
                controller: f.controller,
                validator: f.validator,
                decoration: InputDecoration(label: Text(f.label)),
              ),
            )),
        SizedBox(
          width: 300,
          child: TextFormField(
            obscureText: true,
            controller: model.regPassword,
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
                  firstName: model.firstName.text,
                  lastName: model.lastName.text,
                  email: model.regEmail.text,
                  gender: selectedGender,
                  password: model.regPassword.text,
                  onError: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid Form data"),
                      backgroundColor: Colors.orange,
                    ));
                  },
                  onSuccess: () => pageViewController.jumpToPage(0));
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
