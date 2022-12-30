import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/config/paths.dart';
import 'package:pikc_app/models/image_model.dart';
import 'package:pikc_app/repositories/storage/base_storage_repository.dart';
import 'package:pikc_app/utils/compress_image.dart';
import 'package:pikc_app/utils/session_helper.dart';

import 'package:uuid/uuid.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  StorageRepository(
      {FirebaseStorage? firebaseStorage, FirebaseFirestore? firebaseFirestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  @override
  Future<String> uploadPostImage({required File image}) async {
    final imageId = const Uuid().v4();
    final newImage = await compressFile(image);
    final downloadUrl = await _uploadImage(
      image: newImage,
      ref: 'images/images_by_${SessionHelper.uid}/post_$imageId.jpg',
    );
    return downloadUrl;
  }

  @override
  Future<void> addImageToUserImageCollection(
      {required List<String> toxicChemicalsList,
      required String imageUrl,
      required Timestamp datetime}) async {
    await _firebaseFirestore
        .collection(Paths.scannedImages)
        .doc(SessionHelper.uid)
        .collection(Paths.images)
        .add(ImageModel(
                imageUrl: imageUrl,
                datetime: datetime,
                toxicChemicalsList: toxicChemicalsList)
            .toDocument());
  }

  @override
  Future<List<ImageModel>> getUserHistory() async {
    final querySnapshot = await _firebaseFirestore
        .collection(Paths.scannedImages)
        .doc(SessionHelper.uid)
        .collection(Paths.images)
        .orderBy("datetime", descending: true)
        .get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    final imageModelList =
        allData.map((e) => ImageModel.fromDocument(e)).toList();

    return imageModelList;
  }
}
