import 'package:flutter/material.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

class PagesPage extends StatelessWidget {
  PagesPage({super.key, required this.slug}) {
    print(["Pages be like --- oooo", slug]);
  }

  String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(slug),
      ),
    );
  }
}
