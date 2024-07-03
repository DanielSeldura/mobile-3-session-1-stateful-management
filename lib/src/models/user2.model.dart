import 'package:equatable/equatable.dart';

class UserModel with EquatableMixin {
  final String uid;
  final String? email;
  final String? photoUrl;
  List<String> siblings;

  UserModel(
      {required this.uid, this.email, this.photoUrl, this.siblings = const []});

  @override
  String toString() {
    return "UserModel(uid:$uid, email:$email, photoUrl:$photoUrl, siblings = $siblings)";
  }

  @override
  List<Object?> get props => [uid, email, photoUrl, siblings];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        siblings: json['siblings']);
  }
}
