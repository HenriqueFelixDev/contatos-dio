import 'package:contact_api/contact_api.dart';
import 'package:flutter/material.dart';

import '../pages/contact_edit/contact_edit_page.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  const ContactListItem({super.key, required this.contact});

  void _onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactEditPage(contact: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _onPressed(context),
      visualDensity: VisualDensity.compact,
      isThreeLine: true,
      leading: Hero(
        tag: 'contactPhoto${contact.id}',
        child: const CircleAvatar(radius: 30.0),
      ),
      title: Text(contact.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.phone),
          const _ContactActions(),
        ],
      ),
    );
  }
}

class _ContactActions extends StatelessWidget {
  const _ContactActions();

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        size: 20.0,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.sms),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.alternate_email),
          ),
        ],
      ),
    );
  }
}
