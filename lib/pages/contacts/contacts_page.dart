import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/widgets.dart';
import '../contact_edit/contact_edit_page.dart';
import 'bloc/contacts_bloc.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsBloc(contactApi: context.read()),
      child: const _ContactsView(),
    );
  }
}

class _ContactsView extends StatelessWidget {
  const _ContactsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContactsBloc>();

    final contacts = controller.state.contacts;

    Widget body;

    if (controller.state.status == ContactsStatus.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: contacts.length,
        itemBuilder: (_, i) => ContactListItem(contact: contacts[i]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos DIO'),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: const _CreateContactFloatingActionButton(),
    );
  }
}

class _CreateContactFloatingActionButton extends StatelessWidget {
  const _CreateContactFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ContactEditPage()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
