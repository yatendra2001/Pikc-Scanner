import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pikc_app/repositories/ocr/ocr_repository.dart';

part 'ocr_event.dart';
part 'ocr_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrRepository ocrRepository;
  OcrBloc({
    required this.ocrRepository,
  }) : super(OcrInitial());

  @override
  Stream<OcrState> mapEventToState(OcrEvent event) async* {
    if (event is UserSendImageFileEvent) {
      yield OcrStartedState();
      ocrRepository.getTextFromImage(file: event.file);
      yield OcrCompletedState();
    }
  }
}
