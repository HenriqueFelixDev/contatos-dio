import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String photoUrl;
  final String? note;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.photoUrl,
    this.note,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    String? note,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      note: note ?? this.note,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      phone,
      email,
      photoUrl,
      note,
    ];
  }
}
