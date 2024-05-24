part of '../page.dart';

class _PreviewSection extends StatelessWidget {
  const _PreviewSection(this.controller,
      {this.scrollable = false, this.onDelete});
  final MyDraftPostsController controller;
  final bool scrollable;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _title('Preview')),
            if (onDelete != null)
              IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_rounded,
                  ))
          ],
        ),
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                decoration: _boxDecoration(),
                child: Column(children: [
                  TabBar(
                      isScrollable: scrollable,
                      dividerColor: MyColorHelper.black.withOpacity(0.10),
                      tabs: const [
                        Tab(text: 'Image'),
                        Tab(text: 'Video'),
                        Tab(text: 'Audio'),
                        Tab(text: 'Document')
                      ]),
                  Expanded(
                      child: Obx(() => TabBarView(children: [
                            _myImageWidget(),
                            _myVideoWidget(),
                            _myAudioWidget(),
                            _myDocumentWidget()
                          ])))
                ]))),
      ],
    );
  }

  Widget _myImageWidget() => controller.pickedImage.value != null
      ? Image.memory(fit: BoxFit.cover, controller.pickedImage.value!)
      : controller.selectedPost.imageUrl != null
          ? Image.network(fit: BoxFit.cover, controller.selectedPost.imageUrl!)
          : Icon(Icons.image_rounded,
              color: MyColorHelper.black1.withOpacity(0.50), size: 48);

  Widget _myVideoWidget() => _checkFile(controller.pickedVideo.value)
      ? MyPlayer(path: _getURL(controller.pickedVideo.value!))
      : controller.selectedPost.videoUrl != null
          ? MyPlayer(path: controller.selectedPost.videoUrl!)
          : Icon(Icons.video_library_rounded,
              color: MyColorHelper.black1.withOpacity(0.50), size: 48);

  Widget _myAudioWidget() => _checkFile(controller.pickedAudio.value)
      ? MyPlayer(path: _getURL(controller.pickedAudio.value!), audio: true)
      : controller.selectedPost.audioUrl != null
          ? MyPlayer(path: controller.selectedPost.audioUrl!, audio: true)
          : Icon(Icons.audiotrack_rounded,
              color: MyColorHelper.black1.withOpacity(0.50), size: 48);

  Widget _myDocumentWidget() => _checkFile(controller.pickedDocument.value)
      ? SfPdfViewer.memory(controller.pickedDocument.value!.files.first.bytes!)
      : controller.selectedPost.documentUrl != null
          ? SfPdfViewer.network(controller.selectedPost.documentUrl!)
          : Icon(Icons.description_rounded,
              color: MyColorHelper.black1.withOpacity(0.50), size: 48);

  bool _checkFile(FilePickerResult? pickedFile) =>
      pickedFile != null &&
      pickedFile.files.isNotEmpty &&
      pickedFile.files.first.bytes != null &&
      pickedFile.files.first.bytes!.isNotEmpty;

  String _getURL(FilePickerResult value) =>
      html.Url.createObjectUrlFromBlob(html.Blob([value.files.first.bytes!]));
}
