import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/state/content_type_cubit.dart';
import 'package:plenty_cms/widgets/modal/modal_overlay.dart';

import 'content_type_list.dart';
import 'content_type_settings_modal.dart';
import 'save_buttons.dart';

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
  bool showOverlay = false;
  ContentType? selectedContentType;
  ContentType? rootContentType;

  @override
  void initState() {
    super.initState();

    context
        .read<ContentTypeCubit>()
        .loadSingle(idOrSlug: widget.slug)
        .then((value) {
      setState(() {
        rootContentType = value;
      });
    });

    // context.read<ContentTypeCubit>().loadPage(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    updateContentType() {
      if (rootContentType != null) {
        context.read<ContentTypeCubit>().update(rootContentType!);
      }
    }

    return Scaffold(
        body: Stack(
      children: [
        ModalOverlay(
            child: ListView(
          children: [
            pageTitle(),
            contentList(rootContentType),
            SaveButtons(
              contentType: rootContentType,
              onSubmit: updateContentType,
            )
          ],
        )),
        ...modal()
      ],
    ));
  }

  Widget pageTitle() {
    return Container(
        padding: EdgeInsets.only(bottom: 80),
        child: Text(
          "Content Type",
          style: Theme.of(context).textTheme.headlineLarge,
        ));
  }

  Widget contentList(ContentType? item) {
    if (item == null) {
      return SizedBox.shrink();
    }

    return ContentTypeList(
        contentType: item,
        onSelectType: (val) {
          context.read<ContentTypeCubit>().loadPage(page: 0);

          setState(() {
            selectedContentType = val;
            showOverlay = true;
          });
        });
  }

  List<Positioned> modal() {
    if (!showOverlay || selectedContentType == null) {
      return [];
    }

    return [
      _backdrop(),
      ModalOverlay.offsetRight(
        20,
        child: BlocBuilder<ContentTypeCubit, ContentTypeState>(
          builder: (context, state) => ContentTypeSettingsModal(
            items: state.cacheByPage["0"]?.entities.toList() ?? [], //.toList(),
            contentType: selectedContentType!,
            save: _save,
            close: _cancel,
          ),
        ),
      ),
    ];
  }

  void _save() => setState(() {
        showOverlay = false;
      });

  void _cancel() => setState(() {
        showOverlay = false;
      });

  Positioned _backdrop() {
    return ModalOverlay(
        child: GestureDetector(
      onTap: _cancel,
      child: Container(
        alignment: Alignment.centerRight,
        color: Colors.black.withAlpha(30),
      ),
    ));
  }
}
