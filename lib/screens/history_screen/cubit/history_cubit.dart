import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/models/failure_model.dart';
import 'package:pikc_app/models/image_model.dart';
import 'package:pikc_app/repositories/storage/storage_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final StorageRepository _storageRepository;

  HistoryCubit({
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        // _userRepository = userRepository,
        super(HistoryState.initial());

  Future<void> addImageToUserImageCollection(
      {required List<String> toxicChemicalsList,
      required String imageUrl,
      required Timestamp datetime}) async {
    emit(state.copyWith(status: ImageStatus.retrieving));
    try {
      await _storageRepository.addImageToUserImageCollection(
          toxicChemicalsList: toxicChemicalsList,
          imageUrl: imageUrl,
          datetime: datetime);
      emit(state.copyWith(status: ImageStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: ImageStatus.error));
    }
  }

  Future<void> getUserHistory() async {
    emit(state.copyWith(status: ImageStatus.retrieving));
    try {
      final imageModelsList = await _storageRepository.getUserHistory();
      emit(state.copyWith(
          status: ImageStatus.success, imageModelsList: imageModelsList));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: ImageStatus.error));
    }
  }
}
