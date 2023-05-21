import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/state/todos_cubit.dart';

class TodosPage extends StatelessWidget {
  TodosPage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideNav(),
      body: BlocBuilder<TodosCubit, List<String>>(builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controller,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      context.read<TodosCubit>().addItem(controller.text);
                      controller.clear();
                    },
                    child: const Text("Add item"))
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 400,
                child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state[index]),
                        trailing: GestureDetector(
                          child: const Icon(Icons.delete),
                          onTap: () => context
                              .read<TodosCubit>()
                              .removeItem(state[index]),
                        ),
                      );
                    }),
              ),
            )
          ],
        );
      }),
    );
  }
}
