// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'note': note,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) => Contact.fromMap(json.decode(source) as Map<String, dynamic>);
}
