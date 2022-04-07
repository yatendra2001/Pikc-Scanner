import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

abstract class BaseOcrRepository {
  Future<List<String>> getTextFromImage({required File file});
}
