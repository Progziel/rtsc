import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'colors.dart';

class MyQuillToolBar extends StatelessWidget {
  const MyQuillToolBar({super.key, required this.controller});
  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              QuillToolbarLinkStyleButton(controller: controller),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: controller,
                attribute: Attribute.bold,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: controller,
                attribute: Attribute.italic,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.underline,
              ),
              QuillToolbarColorButton(
                controller: controller,
                isBackground: false,
              ),
              QuillToolbarColorButton(
                controller: controller,
                isBackground: true,
              ),
              QuillToolbarToggleCheckListButton(
                controller: controller,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.ol,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.ul,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.blockQuote,
              ),
              QuillToolbarIndentButton(
                controller: controller,
                isIncrease: true,
              ),
              QuillToolbarIndentButton(
                controller: controller,
                isIncrease: false,
              ),
              QuillToolbarImageButton(
                controller: controller,
              ),
              const VerticalDivider(),
            ],
          ),
        ),
        Divider(color: MyColorHelper.black1.withOpacity(0.10)),
      ],
    );
  }
}

class MyQuillEditor extends StatelessWidget {
  const MyQuillEditor(
      {super.key,
      required this.controller,
      this.minHeight,
      this.focusNode,
      this.readOnly = false,
      this.hints,
      this.textStyles,
      this.nextFocusNode});
  final QuillController controller;
  final FocusNode? focusNode, nextFocusNode;
  final bool readOnly;
  final String? hints;
  final DefaultStyles? textStyles;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: !readOnly ? const EdgeInsets.all(16.0) : null,
      decoration: !readOnly
          ? BoxDecoration(
              color: MyColorHelper.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: MyColorHelper.black1.withOpacity(0.10),
              ))
          : null,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            nextFocusNode?.requestFocus();
          }
        },
        child: QuillEditor.basic(
          focusNode: focusNode,
          configurations: QuillEditorConfigurations(
            embedBuilders: kIsWeb
                ? FlutterQuillEmbeds.editorWebBuilders()
                : FlutterQuillEmbeds.editorBuilders(),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            placeholder: hints,
            minHeight: minHeight,
            controller: controller,
            readOnly: readOnly,
            showCursor: !readOnly,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('de'),
            ),
            customStyles: textStyles,
          ),
        ),
      ),
    );
  }
}
