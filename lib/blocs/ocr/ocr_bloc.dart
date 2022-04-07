import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pikc_app/repositories/ocr/ocr_repository.dart';

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
            await ocrRepository.getTextFromImage(file: event.file);
        yield (state.copyWith(
            ocrStatus: OcrStatus.completed, scannedChemicalsList: chemicals));
      } catch (err) {
        state.copyWith(
          ocrStatus: OcrStatus.failed,
          failure: const Failure(message: 'We were unable to load your feed.'),
        );
      }
    }
  }
}
