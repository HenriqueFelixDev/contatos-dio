import 'package:contact_auth_api/contact_auth_api.dart';
import 'package:contact_auth_api_parse/contact_auth_api_parse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'pages/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    return MultiBlocProvider(
      providers: [
        RepositoryProvider<ContactAuthApi>(
          create: (_) => ContactAuthApiParse(
            googleSignIn: googleSignIn,
            applicationId: dotenv.env['PARSE_APP_ID'] ?? '',
            clientKey: dotenv.env['PARSE_CLIENT_KEY'] ?? '',
            serverUrl: dotenv.env['PARSE_SERVER_URL'] ?? '',
          ),
        ),
        StreamProvider<AuthState>(
          initialData: AuthState.loading,
          create: (context) => context.read<ContactAuthApi>().authState,
        ),
      ],
      child: const MaterialApp(
        title: 'Contatos DIO',
        home: SplashPage(),
      ),
    );
  }
}
