import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';

class HtmlEditorScreen extends StatefulWidget {
  const HtmlEditorScreen(
      {super.key, this.initialVal, this.characterLimit, this.showdesc});
  final String? initialVal;
  final int? characterLimit;
  final bool? showdesc;
  @override
  State<HtmlEditorScreen> createState() => _HtmlEditorScreenState();
}

class _HtmlEditorScreenState extends State<HtmlEditorScreen> {
  final HtmlEditorController controller = HtmlEditorController();
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          leading: widget.showdesc!
              ? null
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context, widget.initialVal);
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
          title: widget.showdesc! ? const Text('Post Description') : null,
          actions: [
            IconButton(
              onPressed: () async {
                String text = await controller.getText();
                if (!mounted) return;
                Navigator.pop(context, text);
              },
              icon: const Icon(Icons.done, color: Colors.green),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                hint: 'Start here...',
                shouldEnsureVisible: true,
                initialText: widget.initialVal,
                spellCheck: true,
                characterLimit: widget.characterLimit,
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeExpandable,
                onButtonPressed:
                    (ButtonType type, bool? status, Function? updateStatus) {
                  return true;
                },
                onDropdownChanged: (DropdownType type, dynamic changed,
                    Function(dynamic)? updateSelectedItem) {
                  return true;
                },
                mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                  return true;
                },
                mediaUploadInterceptor:
                    (PlatformFile file, InsertFileType type) async {
                  return true;
                },
              ),
              otherOptions: OtherOptions(
                  height: MediaQuery.of(context).size.height * 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
