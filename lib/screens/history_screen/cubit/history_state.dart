part of 'history_cubit.dart';

enum ImageStatus {
  initial,
  retrieving,
  success,
  error,
}

class HistoryState extends Equatable {
  final ImageStatus status;

  final Failure failure;

  final List<ImageModel> imageModelsList;

  const HistoryState(
      {required this.status,
      required this.failure,
      required this.imageModelsList});

  factory HistoryState.initial() {
    return const HistoryState(
      status: ImageStatus.initial,
      failure: Failure(),
      imageModelsList: [],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        status,
        failure,
        imageModelsList,
      ];

  HistoryState copyWith(
      {ImageStatus? status,
      Failure? failure,
      List<ImageModel>? imageModelsList}) {
    return HistoryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      imageModelsList: imageModelsList ?? this.imageModelsList,
    );
  }
}
