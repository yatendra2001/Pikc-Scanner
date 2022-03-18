part of 'ocr_bloc.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [];
}

class UserSendImageFileEvent extends OcrEvent {
  final File file;
  const UserSendImageFileEvent({
    required this.file,
  });
}
