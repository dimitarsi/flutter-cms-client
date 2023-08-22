import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/state/content_cubit.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import 'content_type_input_field.dart';

class StoryPageScaffold extends StatelessWidget {
  const StoryPageScaffold(
      {super.key, required this.slug, required this.client});

  final String slug;

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
      appBar: AppBar(),
      body: StoryPage(
        client: client,
        slug: slug,
      ),
    );
  }
}

class PostType {
  PostType({required this.label, required this.id});

  String label;
  String id;
}

class StoryPage extends StatefulWidget {
  StoryPage({super.key, required this.slug, required this.client});

  final String slug;
  final RestClient client;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<StoryPage> createState() => _StoryPageState();
}

// TODO: Use async.dart with StreamBuilder here
class _StoryPageState extends State<StoryPage> {
  Content? item;
  ContentType? contentType;

  @override
  void initState() {
    super.initState();

    final contentCubit = context.read<ContentCubit>();

    contentCubit.loadById(widget.slug).then((_void) {
      setState(() {
        final found = contentCubit.state.cacheByIdOrSlug[widget.slug];
        if (found != null) {
          item = Content.fromJson(found.toJson());
        }
      });
    });
    contentCubit.loadConfigBySlug(widget.slug).then((_void) {
      setState(() {
        contentType =
            contentCubit.state.cacheCTBySlug[widget.slug]?.cloneDeep();
      });
    });
  }

  void createOrUpdateStory({VoidCallback? onSave}) {
    var formState = widget.formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    formState.save();
    onSave?.call();
  }

  ElevatedButton saveButton({VoidCallback? onSave}) {
    return ElevatedButton(
        onPressed: () => createOrUpdateStory(onSave: onSave),
        child: const Text("Save"));
  }

  bool isRefListLoading = false;

  @override
  Widget build(BuildContext context) {
    final client = context.read<ContentCubit>().client;

    return Form(
      key: widget.formKey,
      child: BlocBuilder<ContentCubit, ContentCubitState>(
          builder: ((context, state) {
        if (item == null || contentType == null) {
          return Text("Loading");
        }

        final field = ContentTypeInputField(
            contentType: contentType, content: item?.data);

        return Column(
          children: [
            Expanded(
              child: ListView(children: field.getInputFields()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                saveButton(onSave: () {
                  if (item != null) {
                    client.updateStory(widget.slug, item!);
                  }
                })
              ],
            )
          ],
        );
      })),
    );
  }
}
