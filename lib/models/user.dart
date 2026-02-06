import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? birthDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
  });

  @override
  List<Object?> get props => [id, name, email, phone, birthDate];
}
