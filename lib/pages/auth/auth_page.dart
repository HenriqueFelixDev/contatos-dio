import 'dart:async';

import 'package:contact_auth_api/contact_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../contacts/contacts_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription =
        context.read<ContactAuthApi>().authState.listen((authState) {
      if (authState == AuthState.authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ContactsPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<ContactAuthApi>().loginWithGoogle(),
          child: const Text('Login com o Google'),
        ),
      ),
    );
  }
}
