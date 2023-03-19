import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Login page"),
                Divider(
                  thickness: 1,
                  height: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: onPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Submit"),
                    ))
              ],
            ),
          )
          // ,
          // Column(
          //   children: [
          //     Text("Username"),
          //     Expanded(child: TextField()),
          //     Text("Password"),
          //     Expanded(
          //       child: TextField(
          //         obscureText: true,
          //       ),
          //     ),
          //     TextButton(onPressed: onPressed, child: Text("Submit"))
          //   ],
          // ),
        ],
      ),
    );
  }

  void onPressed() {}
}
