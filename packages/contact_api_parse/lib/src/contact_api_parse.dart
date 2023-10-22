import 'package:contact_api/contact_api.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:rxdart/rxdart.dart';

extension ContactParse on Contact {
  ParseObject toParse() {
    return ParseObject('Contact')
      ..set('name', name)
      ..set('phone', phone)
      ..set('email', email)
      ..set('photo', photoUrl)
      ..set('note', note)
      ..objectId = id;
  }
}

extension ParseContact on ParseObject {
  Contact toContact() {
    return Contact(
      id: objectId ?? '',
      name: get('name'),
      phone: get('phone'),
      email: get('email'),
      photoUrl: get('photo'),
      note: get('note'),
    );
  }
}

class ContactApiParse implements ContactApi {
  ContactApiParse();

  final _contactsSubject = BehaviorSubject<List<Contact>>.seeded([]);

  @override
  Stream<List<Contact>> get contacts => _contactsSubject.asBroadcastStream();

  @override
  Future<void> fetchContacts() async {
    final response = await ParseObject('Contact').getAll();

    final contacts = response.results
        ?.map((result) => (result as ParseObject).toContact())
        .toList();

    _contactsSubject.sink.add(contacts ?? []);
  }

  @override
  Future<void> create(Contact contact) async {
    final parseContact = contact.toParse();
    final contacts = List<Contact>.from(_contactsSubject.value);

    final user = await ParseUser.currentUser() as ParseUser?;
    parseContact.setACL(ParseACL(owner: user));

    final response = await parseContact.create();

    if (!response.success) {
      throw Exception('Erro ao criar contato');
    }

    contacts.add(parseContact.toContact());

    _contactsSubject.sink.add(contacts);
  }

  @override
  Future<void> delete(String id) async {
    final contacts = List<Contact>.from(_contactsSubject.value);
    final removedIndex = contacts.indexWhere((contact) => contact.id == id);

    if (removedIndex == -1) {
      throw Exception('Contato não encontrado');
    }

    contacts.removeAt(removedIndex);
    _contactsSubject.sink.add(contacts);

    await ParseObject('Contact').delete(id: id);
  }

  @override
  Future<void> update(Contact contact) async {
    final contacts = List<Contact>.from(_contactsSubject.value);
    final updatedIndex = contacts.indexWhere((item) => item.id == contact.id);

    if (updatedIndex == -1) {
      throw Exception('Contato não encontrado');
    }

    contacts[updatedIndex] = contact;
    _contactsSubject.sink.add(contacts);

    await contact.toParse().update();
  }
}
