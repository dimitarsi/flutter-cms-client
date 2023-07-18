import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/screens/content_types/content_type_inputs.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/state/content_type_cubit.dart';

import '../../app_router.dart';

class StoryConfigPage extends StatefulWidget {
  StoryConfigPage({super.key, required this.slug});

  final String slug;
  final GlobalKey<FormState> contentTypeFormKey = GlobalKey();

  @override
  State<StoryConfigPage> createState() => _StoryConfigPageState();
}

class PaddedText extends StatelessWidget {
  final String data;

  const PaddedText(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(data),
    );
  }
}

class _StoryConfigPageState extends State<StoryConfigPage> {
  // ContentType? storyConfig;
  // late Iterable<ContentType> referenceFields;

  final TextEditingController groupNameController = TextEditingController();
  final groupNameLabel = const InputDecoration(labelText: "Content type name");
  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15));
  ButtonStyle addFieldOrRowButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(3), minimumSize: const Size(30, 30));
  String? referenceListValue;

  @override
  void initState() {
    super.initState();

    context.read<ContentTypeCubit>().loadSingle(idOrSlug: widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ContentTypeCubit, ContentTypeState>(
      builder: (context, state) {
        final item = state.cacheById[widget.slug]?.cloneDeep();

        return ListView(
          children: [
            pageTitle(),
            Container(
              height: 80,
            ),
            if (item != null) ContentTypeList(contentType: item),
            saveButtons(item)
          ],
        );
      },
    ));
  }

  Widget pageTitle() {
    return Text(
      "Content Type",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget saveButtons(ContentType? contentType) {
    if (contentType == null) {
      return const SizedBox.shrink();
    }

    updateContentType() => context.read<ContentTypeCubit>().update(contentType);

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: 450,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  } else {
                    context.go(AppRouter.contentTypeListPath);
                  }
                },
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: updateContentType,
              style: buttonStyle,
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}

class ContentTypeList extends StatefulWidget {
  const ContentTypeList({super.key, required this.contentType});

  final ContentType contentType;

  @override
  State<ContentTypeList> createState() =>
      _ContentTypeListState(contentType: contentType);
}

class _ContentTypeListState extends State<ContentTypeList> {
  _ContentTypeListState({required this.contentType});

  ContentType contentType;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ContentTypeInputs(
      contentType: contentType,
      onChange: () {
        setState(() {});
      },
    ));
  }

  Widget addNewFieldButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        child: Text("Edit"),
        onPressed: () {
          final formKey = GlobalKey<FormState>();

          showGeneralDialog(
              context: context,
              anchorPoint: Offset(1, 0.5),
              pageBuilder: (context, anim, animcontrl) {
                final buttonWithInput = [
                  TextFormField(
                      initialValue: contentType.name,
                      decoration: InputDecoration(label: Text("Name")),
                      onSaved: (val) {
                        if (val == null || val.isEmpty) {
                          return;
                        }

                        final newContentTypeChild = ContentType(
                            name: val, slug: slugify(val), type: "text");

                        if (contentType.children == null) {
                          contentType.children = [newContentTypeChild];
                          if (contentType.type != "composite") {
                            contentType.type = "composite";
                            contentType.name = "";
                          }
                        } else {
                          contentType.children!.add(newContentTypeChild);
                        }
                        print("Add more children");
                        setState(() {});
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text("Close")),
                      ElevatedButton(
                          onPressed: () {
                            formKey.currentState?.save();
                            context.pop();
                          },
                          child: Text("Save"))
                    ],
                  )
                ];

                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Form(
                    key: formKey,
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(20),
                      child: Container(
                        color: Colors.white,
                        width: max(700,
                            max(300, MediaQuery.of(context).size.width * 0.25)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: buttonWithInput),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
