import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Home Page")
          // SideNav(),
          // Row(children: [Text("Homepage")])
        ]),
      ),
    );
  }
}
