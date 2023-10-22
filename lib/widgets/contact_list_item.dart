import 'package:contact_api/contact_api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../pages/contact_edit/contact_edit_page.dart';
import 'contact_photo.dart';

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
      leading: ContactPhoto(
        contactId: contact.id,
        photoUrl: contact.photoUrl,
        radius: 30.0,
      ),
      title: Text(contact.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.phone),
          _ContactActions(contact: contact),
        ],
      ),
    );
  }
}

class _ContactActions extends StatelessWidget {
  final Contact contact;
  const _ContactActions({required this.contact});

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    }
  }

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
            onPressed: () => _launchUrl('tel:${contact.phone}'),
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _launchUrl('sms:${contact.phone}'),
            icon: const Icon(Icons.sms),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _launchUrl('mailto:${contact.email}'),
            icon: const Icon(Icons.alternate_email),
          ),
        ],
      ),
    );
  }
}
