import 'package:brasil_fields/brasil_fields.dart';
import 'package:contact_api/contact_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_edit_state.dart';

class ContactEditBloc extends Cubit<ContactEditState> {
  final ContactApi _contactApi;

  ContactEditBloc({required ContactApi contactApi, Contact? initialValue})
      : _contactApi = contactApi,
        super(ContactEditState.initial(initialValue: initialValue));

  bool get isCreating => state.isCreating;
  bool get isUpdating => state.isUpdating;

  void setName(String value) => emit(state.copyWith(name: value));
  void setEmail(String value) => emit(state.copyWith(email: value));
  void setPhone(String value) => emit(state.copyWith(phone: value));
  void setPhotoUrl(String value) => emit(state.copyWith(photoUrl: value));
  void setNote(String value) => emit(state.copyWith(note: value));

  Future<void> save() async {
    try {
      emit(state.copyWith(status: ContactEditStatus.saving));

      if (state.isCreating) {
        await _contactApi.create(state.toContact());
      } else {
        await _contactApi.update(state.toContact());
      }

      emit(state.copyWith(status: ContactEditStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContactEditStatus.failure));
    }
  }
}
