import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

abstract class BaseOcrRepository {
  Future<void> getTextFromImage({required File file});
}
