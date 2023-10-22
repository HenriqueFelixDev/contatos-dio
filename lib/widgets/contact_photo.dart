import 'dart:io';

import 'package:flutter/material.dart';

class ContactPhoto extends StatelessWidget {
  final String contactId;
  final String photoUrl;
  final double radius;

  const ContactPhoto({
    super.key,
    required this.contactId,
    required this.photoUrl,
    this.radius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'contactHero$contactId',
      child: CircleAvatar(
        radius: radius,
        backgroundImage: photoUrl.isEmpty ? null : FileImage(File(photoUrl)),
      ),
    );
  }
}
