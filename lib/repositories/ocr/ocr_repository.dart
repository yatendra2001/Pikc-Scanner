import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

import 'package:pikc_app/repositories/ocr/base_ocr_repository.dart';
import 'package:pikc_app/utils/chemicals_list_constant.dart';

class OcrRepository extends BaseOcrRepository {
  @override
  Future<List<String>> getTextFromImage({required File file}) async {
    final inputImage = InputImage.fromFile(file);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text.trim();
    String newText = text.replaceAll(' ', '');
    newText = newText.replaceAll('.', ',');
    List<String> wordsInText = newText.toUpperCase().split(',');
    List<String> toxicChemicalsList = [];
    for (String str in wordsInText) {
      if (kToxicChemicalsList.contains(str)) {
        toxicChemicalsList.add(str);
      }
    }
    return toxicChemicalsList;
  }
}
