import 'dart:collection';
import 'dart:convert';

import 'package:contact_api/contact_api.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'contacts_state.dart';
part 'contacts_event.dart';

class ContactsBloc extends HydratedBloc<ContactsEvent, ContactsState> {
  final ContactApi _contactApi;

  ContactsBloc({
    required ContactApi contactApi,
  })  : _contactApi = contactApi,
        super(ContactsState.initial()) {
    on<_ContactsStarted>(_onStarted);
    add(const _ContactsStarted());
  }

  Future<void> _onStarted(_ContactsStarted event, Emitter emit) async {
    emit(state.copyWith(status: ContactsStatus.loading));
    await _contactApi.fetchContacts();

    await emit.forEach(
      _contactApi.contacts,
      onData: (contacts) => state.copyWith(contacts: contacts, status: ContactsStatus.data),
      onError: (_, __) => state.copyWith(status: ContactsStatus.failure),
    );
  }

  @override
  ContactsState fromJson(Map<String, dynamic> json) {
    return ContactsState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(ContactsState state) {
    return state.toMap();
  }
}
