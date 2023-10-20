import 'dart:async';

import 'package:contact_auth_api/contact_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_page.dart';
import '../contacts/contacts_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authSubscription =
          context.read<ContactAuthApi>().authState.listen((authState) {
        Widget page;

        if (authState == AuthState.authenticated) {
          page = const ContactsPage();
        } else {
          page = const AuthPage();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
