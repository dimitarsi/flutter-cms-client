import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();

    context.read<ContentTypeCubit>().loadSingle(idOrSlug: widget.slug);
    context.read<ContentTypeCubit>().loadPage(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ContentTypeCubit, ContentTypeState>(
      builder: (context, state) {
        final item = state.cacheById[widget.slug]?.cloneDeep();
        final items = state.cacheByPage["1"]?.entities ?? [];

        return Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ListView(
                  children: [
                    pageTitle(),
                    Container(
                      height: 80,
                    ),
                    if (item != null)
                      ContentTypeList(
                          contentType: item,
                          onSelectType: () {
                            setState(() {
                              showOverlay = true;
                            });
                          }),
                    saveButtons(item)
                  ],
                )),
            if (showOverlay) ...[
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showOverlay = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.black.withAlpha(30),
                    ),
                  )),
              Positioned(
                right: 20,
                top: 20,
                bottom: 20,
                child: Container(
                  padding: EdgeInsets.all(20),
                  constraints: BoxConstraints(
                      maxWidth: 600,
                      maxHeight: MediaQuery.of(context).size.height - 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items.elementAt(index).name),
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
              ),
            ],
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
  ContentTypeList({super.key, required this.contentType, this.onSelectType});

  final ContentType contentType;
  final void Function()? onSelectType;

  @override
  State<ContentTypeList> createState() =>
      _ContentTypeListState(contentType: contentType);
}

class _ContentTypeListState extends State<ContentTypeList> {
  _ContentTypeListState({required this.contentType});

  ContentType contentType;

  @override
  Widget build(BuildContext context) {
    return ContentTypeInputs(
      contentType: contentType,
      onChange: () {
        setState(() {});
      },
      onSelectType: (ContentType contentType) {
        widget.onSelectType?.call();
      },
      onNavigateTo: (path) => context.push(path),
    );
  }

  Widget saveButtons(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Update"))
        ],
      ),
    );
  }
}
