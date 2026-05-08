import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  const UserProfileEntity({required this.id, required this.email});

  final String id;
  final String email;

  @override
  List<Object?> get props => ['id', 'email'];
}
