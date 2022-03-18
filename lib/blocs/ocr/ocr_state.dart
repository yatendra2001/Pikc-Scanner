part of 'ocr_bloc.dart';

abstract class OcrState extends Equatable {
  const OcrState();

  @override
  List<Object> get props => [];
}

class OcrInitial extends OcrState {}

class OcrStartedState extends OcrState {}

class OcrCompletedState extends OcrState {}

class OcrFailedState extends OcrState {}
