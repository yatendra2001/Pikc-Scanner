import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class ImageHelper {
  static Future<File?> pickFromSource({
    required BuildContext context,
    required CropStyle cropStyle,
    required String title,
    required ImageSource source,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        cropStyle: cropStyle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: kScaffoldBackgroundColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(),
        compressQuality: 100,
      );
      return File(croppedFile!.path);
    }
    return null;
  }
}
