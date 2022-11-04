import 'dart:io';

abstract class BaseOcrRepository {
  Future<List<String>> getToxicChemicalsFromImage({required File file});
}
