import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pikc_app/repositories/ocr/ocr_repository.dart';
import 'package:pikc_app/repositories/storage/storage_repository.dart';
import 'package:pikc_app/screens/history_screen/cubit/history_cubit.dart';
import 'package:pikc_app/utils/session_helper.dart';

import '../../models/models.dart';

part 'ocr_event.dart';
part 'ocr_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrRepository ocrRepository;
  OcrBloc({
    required this.ocrRepository,
  }) : super(OcrState.initial());

  @override
  Stream<OcrState> mapEventToState(OcrEvent event) async* {
    if (event is UserSendImageFileEvent) {
      yield (state.copyWith(ocrStatus: OcrStatus.started));
      try {
        final chemicals =
            await ocrRepository.getToxicChemicalsFromImage(file: event.file);
        SessionHelper.currentImageUrl = await StorageRepository()
            .uploadPostImage(image: SessionHelper.currentFile!);
        SessionHelper.currentToxicChemicalsList = chemicals;
        yield (state.copyWith(
            ocrStatus: OcrStatus.completed, scannedChemicalsList: chemicals));
      } catch (err) {
        yield (state.copyWith(
          ocrStatus: OcrStatus.failed,
          failure: Failure(message: err.toString()),
        ));
      }
    }
  }
}
