import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikc_app/models/image_model.dart';

abstract class BaseStorageRepository {
  Future<String> uploadPostImage({required File image});
  Future<void> addImageToUserImageCollection(
      {required List<String> toxicChemicalsList,
      required String imageUrl,
      required Timestamp datetime});

  Future<List<ImageModel>> getUserHistory();
}
