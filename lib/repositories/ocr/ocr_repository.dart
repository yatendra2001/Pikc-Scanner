import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

import 'package:pikc_app/repositories/ocr/base_ocr_repository.dart';
import 'package:pikc_app/utils/chemicals_list_constant.dart';

class OcrRepository extends BaseOcrRepository {
  @override
  Future<List<String>> getToxicChemicalsFromImage({required File file}) async {
    final inputImage = InputImage.fromFile(file);
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);
    String text = recognizedText.text.trim();
    String newText = text.replaceAll(' ', '');
    newText = newText.replaceAll('.', ',');
    newText = newText.replaceAll(':', ',');
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
