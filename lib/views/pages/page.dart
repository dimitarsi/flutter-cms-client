import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';

class PagesPage extends StatelessWidget {
  PagesPage({super.key, required this.slug}) {
    print(["Pages be like --- oooo", this.slug]);
  }

  String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(slug),
      ),
    );
  }
}
