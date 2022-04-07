part of 'ocr_bloc.dart';

enum OcrStatus { initial, started, completed, failed }

class OcrState extends Equatable {
  final List<String> scannedChemicalsList;
  final OcrStatus ocrStatus;
  final Failure failure;

  const OcrState({
    required this.scannedChemicalsList,
    required this.ocrStatus,
    required this.failure,
  });

  factory OcrState.initial() {
    return const OcrState(
      scannedChemicalsList: [],
      ocrStatus: OcrStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [scannedChemicalsList, ocrStatus, failure];

  OcrState copyWith({
    List<String>? scannedChemicalsList,
    OcrStatus? ocrStatus,
    Failure? failure,
  }) {
    return OcrState(
      scannedChemicalsList: scannedChemicalsList ?? this.scannedChemicalsList,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      failure: failure ?? this.failure,
    );
  }
}
