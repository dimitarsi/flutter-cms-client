import 'package:flutter/material.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

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
        decoration: const BoxDecoration(color: Colors.blue),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Home Page")
          // SideNav(),
          // Row(children: [Text("Homepage")])
        ]),
      ),
    );
  }
}
