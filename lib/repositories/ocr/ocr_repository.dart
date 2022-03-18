import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_ml_kit/src/vision/vision.dart';
import 'dart:io';

import 'package:pikc_app/repositories/ocr/base_ocr_repository.dart';

class OcrRepository extends BaseOcrRepository {
  @override
  Future<void> getTextFromImage({required File file}) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final textDetector = GoogleMlKit.vision.textDetector();
      final RecognisedText recognisedText =
          await textDetector.processImage(inputImage);
      String text = recognisedText.text.trim();
      String newText = text.replaceAll(RegExp(r'[^\w\s]+'), '');
      var wordsInText = newText.split(' ');
      print(wordsInText);
      print("Image to text is :" + text);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }
}
