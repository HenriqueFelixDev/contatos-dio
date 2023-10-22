
import 'models/models.dart';

abstract interface class ContactApi {
  Stream<List<Contact>> get contacts;

  Future<void> fetchContacts();
  Future<void> create(Contact contact);
  Future<void> update(Contact contact);
  Future<void> delete(String id);
}