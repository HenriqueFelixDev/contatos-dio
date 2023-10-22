part of 'contacts_bloc.dart';

sealed class ContactsEvent {
  const ContactsEvent();
}

class _ContactsStarted extends ContactsEvent {
  const _ContactsStarted();
}