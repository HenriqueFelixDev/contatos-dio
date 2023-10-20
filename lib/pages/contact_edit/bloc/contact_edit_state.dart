part of 'contact_edit_bloc.dart';

enum ContactEditStatus {
  initial,
  saving,
  success,
  failure;
}

class ContactEditState extends Equatable {
  final ContactEditStatus status;
  final Contact? initialValue;
  final String name;
  final String phone;
  final String email;
  final String photoUrl;
  final String? note;

  const ContactEditState({
    required this.status,
    required this.initialValue,
    required this.name,
    required this.phone,
    required this.email,
    required this.photoUrl,
    this.note,
  });

  factory ContactEditState.initial({Contact? initialValue}) {
    return ContactEditState(
      status: ContactEditStatus.initial,
      initialValue: initialValue,
      name: initialValue?.name ?? '',
      phone: initialValue?.phone ?? '',
      email: initialValue?.email ?? '',
      photoUrl: initialValue?.photoUrl ?? '',
      note: initialValue?.note,
    );
  }

  bool get isCreating => initialValue?.id == null;
  bool get isUpdating => !isCreating;

  Contact toContact() {
    return Contact(
      id: initialValue?.id ?? '',
      name: name,
      phone: phone,
      email: email,
      photoUrl: photoUrl,
      note: note,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialValue,
        name,
        phone,
        email,
        photoUrl,
        note,
      ];

  @override
  bool get stringify => true;

  ContactEditState copyWith({
    ContactEditStatus? status,
    Contact? initialValue,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    String? note,
  }) {
    return ContactEditState(
      status: status ?? this.status,
      initialValue: initialValue ?? this.initialValue,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      note: note ?? this.note,
    );
  }
}
