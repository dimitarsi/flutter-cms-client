import 'package:flutter/material.dart';

import '../../service/client/client.dart';

class ComponentEditPage extends StatefulWidget {
  const ComponentEditPage(
      {super.key, required this.client, required this.componentId});

  final RestClient client;
  final String componentId;

  @override
  State<ComponentEditPage> createState() => _ComponentEditPageState();
}

class _ComponentEditPageState extends State<ComponentEditPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("Component Edit Page - ${widget.componentId}")],
    );
  }
}
