import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pikc_app/keys.dart';
import 'dart:io';

import 'package:pikc_app/repositories/ocr/base_ocr_repository.dart';
import 'package:pikc_app/utils/chemicals_list_constant.dart';

class OcrRepository extends BaseOcrRepository {
  @override
  Future<List<String>> getToxicChemicalsFromImage({required File file}) async {
    // final inputImage = InputImage.fromFile(file);
    final bytes = file.readAsBytesSync();
    List<String> wordsInText = [];
    var uri = Uri.parse(
        "https://eastus.api.cognitive.microsoft.com/vision/v3.1/ocr?language=unk&detectOrientation=true");
    var request = http.Request("POST", uri)
      ..headers['Ocp-Apim-Subscription-Key'] = azureAPIKey
      ..headers['Content-Type'] = "application/octet-stream"
      ..bodyBytes = bytes;

    var response = await request.send();
    print(request);
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> myMap = json.decode(value);
      List<dynamic> lines = myMap["regions"][0]["lines"];
      lines.forEach((line) {
        (line).forEach((key, value) {
          if (key == "words") {
            value.forEach((word) {
              (word).forEach((key, value) {
                if (key == "text") wordsInText.add(value);
              });
            });
          }
        });
      });
    });
    // final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    // final RecognizedText recognizedText =
    //     await textDetector.processImage(inputImage);
    // String text = recognizedText.text.trim();
    // String newText = text.replaceAll(' ', '');
    // newText = newText.replaceAll('.', ',');
    // newText = newText.replaceAll(':', ',');
    // List<String> wordsInText = newText.toUpperCase().split(',');
    List<String> toxicChemicalsList = [];
    for (String str in wordsInText) {
      if (kToxicChemicalsList.contains(str)) {
        toxicChemicalsList.add(str);
      }
    }
    return wordsInText;
  }
}
