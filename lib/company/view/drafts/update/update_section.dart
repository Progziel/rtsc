part of '../page.dart';

class _CreateSection extends StatefulWidget {
  const _CreateSection(this.controller, {required this.landscape});
  final MyDraftPostsController controller;
  final bool landscape;

  @override
  State<_CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<_CreateSection> {
  final _focusIndex = 0.obs;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _subtitleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    _titleFocusNode.addListener(_onFocusChange);
    _subtitleFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (_titleFocusNode.hasFocus) {
      _focusIndex.value = 0;
    } else if (_subtitleFocusNode.hasFocus) {
      _focusIndex.value = 1;
    } else if (_descriptionFocusNode.hasFocus) {
      _focusIndex.value = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _addButton(
                    toolTip: 'Add Image',
                    icon: Icons.image_rounded,
                    onTap: () async {
                      DefaultTabController.of(context).animateTo(0);
                      imagePicker(context,
                          aspectRatio: 16 / 9,
                          message: '16:9',
                          onSelect: (Uint8List? pickedFile) =>
                              widget.controller.pickedImage.value = pickedFile);
                      _removeOtherSelections(0);
                    }),
                _addButton(
                    toolTip: 'Add Video',
                    icon: Icons.video_library_rounded,
                    onTap: () async {
                      DefaultTabController.of(context).animateTo(1);
                      widget.controller.pickedVideo.value = await FilePicker
                          .platform
                          .pickFiles(type: FileType.video);
                      _removeOtherSelections(1);
                    }),
                _addButton(
                  toolTip: 'Add Audio',
                  icon: Icons.audiotrack_rounded,
                  onTap: () async {
                    DefaultTabController.of(context).animateTo(2);
                    FilePickerResult? pickedFile = await FilePicker.platform
                        .pickFiles(type: FileType.audio);
                    if (pickedFile != null &&
                        pickedFile.files.isNotEmpty &&
                        pickedFile.files.first.bytes != null &&
                        pickedFile.files.first.bytes!.isNotEmpty) {
                      widget.controller.pickedAudio.value = pickedFile;
                      _removeOtherSelections(2);
                    }
                  },
                ),
                _addButton(
                  toolTip: 'Add Document',
                  icon: Icons.description_rounded,
                  onTap: () async {
                    DefaultTabController.of(context).animateTo(3);
                    FilePickerResult? pickedFile = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom, allowedExtensions: ['pdf']);
                    if (pickedFile != null &&
                        pickedFile.files.isNotEmpty &&
                        pickedFile.files.first.bytes != null &&
                        pickedFile.files.first.bytes!.isNotEmpty) {
                      widget.controller.pickedDocument.value = pickedFile;
                      _removeOtherSelections(3);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(() => MyQuillToolBar(
              controller: _focusIndex.value == 0
                  ? widget.controller.titleController
                  : _focusIndex.value == 1
                      ? widget.controller.subtitleController
                      : _focusIndex.value == 2
                          ? widget.controller.descriptionController
                          : QuillController.basic())),
          const SizedBox(height: 16.0),
          widget.landscape
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _editors(),
                  ),
                )
              : _editors()
        ],
      ),
    );
  }

  Widget _addButton(
          {required String toolTip,
          required IconData icon,
          required VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Tooltip(
          message: toolTip,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32.0),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: MyColorHelper.black.withOpacity(0.10),
              child: Icon(icon, color: MyColorHelper.black.withOpacity(0.25)),
            ),
          ),
        ),
      );

  void _removeOtherSelections(int selectedIndex) {
    if (selectedIndex != 0) {
      widget.controller.pickedImage.value = null;
      widget.controller.selectedPost.imageUrl = null;
    }
    if (selectedIndex != 1) {
      widget.controller.pickedVideo.value = null;
      widget.controller.selectedPost.videoUrl = null;
      widget.controller.selectedPost.videoThumbnailUrl = null;
    }
    if (selectedIndex != 2) {
      widget.controller.pickedAudio.value = null;
      widget.controller.selectedPost.audioUrl = null;
    }
    if (selectedIndex != 3) {
      widget.controller.pickedDocument.value = null;
      widget.controller.selectedPost.documentUrl = null;
    }
  }

  Widget _editors() => Column(
        children: [
          MyQuillEditor(
            hints: 'Title',
            focusNode: _titleFocusNode,
            nextFocusNode: _subtitleFocusNode,
            controller: widget.controller.titleController,
          ),
          const SizedBox(height: 16.0),
          MyQuillEditor(
            hints: 'Subtitle',
            focusNode: _subtitleFocusNode,
            nextFocusNode: _descriptionFocusNode,
            controller: widget.controller.subtitleController,
          ),
          const SizedBox(height: 16.0),
          MyQuillEditor(
            minHeight: 150.0,
            hints: 'Description',
            focusNode: _descriptionFocusNode,
            controller: widget.controller.descriptionController,
          ),
          Obx(() => CheckboxListTile(
                title: Text(widget.controller.showEmail.value
                    ? companyUniversalController.currentUser.email ?? 'Null'
                    : 'Attach email?'),
                value: widget.controller.showEmail.value,
                onChanged: (v) => widget.controller.showEmail.value =
                    !widget.controller.showEmail.value,
              )),
        ],
      );
}
