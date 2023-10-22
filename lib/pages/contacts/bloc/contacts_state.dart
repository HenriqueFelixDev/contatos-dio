part of 'contacts_bloc.dart';

enum ContactsStatus {
  initial,
  loading,
  data,
  failure;
}

class ContactsState extends Equatable {
  final ContactsStatus status;
  final UnmodifiableListView<Contact> contacts;

  const ContactsState({required this.status, required this.contacts});

  factory ContactsState.initial() {
    return ContactsState(
      status: ContactsStatus.initial,
      contacts: UnmodifiableListView([]),
    );
  }

  @override
  List<Object?> get props => [status, contacts];

  @override
  bool get stringify => true;

  ContactsState copyWith({
    ContactsStatus? status,
    List<Contact>? contacts,
  }) {
    return ContactsState(
      status: status ?? this.status,
      contacts:
          contacts != null ? UnmodifiableListView(contacts) : this.contacts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status.name,
      'contacts': contacts.map((element) => element.toMap()).toList(),
    };
  }

  factory ContactsState.fromMap(Map<String, dynamic> map) {
    return ContactsState(
      status: ContactsStatus.values
          .firstWhere((item) => item.name == map['status'] as String),
      contacts: UnmodifiableListView<Contact>((map['contacts'] as List)
          .map((contactMap) => Contact.fromMap(contactMap))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactsState.fromJson(String source) =>
      ContactsState.fromMap(json.decode(source) as Map<String, dynamic>);
}
