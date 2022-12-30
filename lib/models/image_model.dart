import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String imageUrl;
  final Timestamp datetime;
  final List<String> toxicChemicalsList;
  const ImageModel({
    required this.imageUrl,
    required this.datetime,
    required this.toxicChemicalsList,
  });

  ImageModel copyWith({
    String? imageUrl,
    Timestamp? datetime,
    List<String>? toxicChemicalsList,
  }) {
    return ImageModel(
      imageUrl: imageUrl ?? this.imageUrl,
      datetime: datetime ?? this.datetime,
      toxicChemicalsList: toxicChemicalsList ?? this.toxicChemicalsList,
    );
  }

  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'datetime': datetime.microsecondsSinceEpoch,
      'toxicChemicalsList': toxicChemicalsList,
    };
  }

  factory ImageModel.fromDocument(Map<String, dynamic> data) {
    List<String> chemicalsList = [];
    for (var map in data['toxicChemicalsList']) {
      chemicalsList.add(map);
    }
    return ImageModel(
      imageUrl: data['imageUrl'] ?? '',
      datetime: Timestamp.fromMicrosecondsSinceEpoch(data['datetime']),
      toxicChemicalsList: chemicalsList,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [imageUrl, datetime, toxicChemicalsList];
}
