import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

void imagePicker(BuildContext context,
    {double aspectRatio = 1 / 1,
    String message = 'square (1x1)',
    required Function onSelect}) async {
  final controller = CropController();
  final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
  Uint8List? imageBytes;
  if (pickedFile != null &&
      pickedFile.files.isNotEmpty &&
      pickedFile.files.first.bytes != null &&
      pickedFile.files.first.bytes!.isNotEmpty) {
    imageBytes = pickedFile.files.first.bytes!;
  }

  if (imageBytes != null && context.mounted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            const Text('Selected Image',
                textAlign: TextAlign.center,
                style: TextStyle(color: MyColorHelper.black1)),
            Text(
              'It\'s suggested to select $message image for better experience',
              style: const TextStyle(fontSize: 14, color: MyColorHelper.black1),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: AspectRatio(
          aspectRatio: aspectRatio,
          child: Crop(
            image: imageBytes!,
            controller: controller,
            onCropped: (image) {
              onSelect(image);
              Get.back();
            },
            aspectRatio: aspectRatio,
            // initialSize: 0.5,
            // initialArea: Rect.fromLTWH(240, 212, 800, 600),
            // initialRectBuilder: (rect) => Rect.fromLTRB(
            //     rect.left + 24, rect.top + 32, rect.right - 24, rect.bottom - 32
            // ),
            // withCircleUi: true,
            baseColor: MyColorHelper.red1,
            maskColor: Colors.white.withAlpha(100),
            progressIndicator: const CircularProgressIndicator(
              color: MyColorHelper.red1,
            ),
            onMoved: (newRect) {
              // do something with current crop rect.
            },
            onStatusChanged: (status) {
              // do something with current CropStatus
            },
            willUpdateScale: (newScale) {
              // if returning false, scaling will be canceled
              return newScale < 5;
            },
            cornerDotBuilder: (size, edgeAlignment) =>
                const DotControl(color: Colors.blue),
            clipBehavior: Clip.none,
            interactive: true,
            // fixCropRect: true,
            // formatDetector: (image) {},
            // imageCropper: myCustomImageCropper,
            // imageParser: (image, {format}) {},
          ),
        ),
        // content: AspectRatio(
        //   aspectRatio: aspectRatio,
        //   child: Image.memory(fit: BoxFit.cover, imageBytes!),
        // ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          InkWell(
              hoverColor: Colors.transparent,
              child: const Text('Cancel'),
              onTap: () => Get.back()),
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () => controller.crop(),
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}
