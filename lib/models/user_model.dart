import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? uid;
  final String? name;
  final String? number;
  final String? email;
  final List<String>? allergicList;

  const UserModel({
    required this.uid,
    required this.name,
    this.number,
    this.email,
    this.allergicList,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? number,
    String? email,
    List<String>? allergicList,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      number: number ?? this.number,
      email: email ?? this.email,
      allergicList: allergicList ?? this.allergicList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'number': number,
      'email': email,
      'allergicList': allergicList,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      number: map['number'],
      email: map['email'],
      allergicList: List<String>.from(map['allergicList']),
    );
  }

  @override
  List<Object> get props {
    return [
      uid!,
      name!,
      number!,
      email!,
      allergicList!,
    ];
  }
}
