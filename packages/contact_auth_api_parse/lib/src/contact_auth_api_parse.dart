import 'package:contact_auth_api/contact_auth_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:rxdart/subjects.dart';

class ContactAuthApiParse implements ContactAuthApi {
  final _authStateSubject = BehaviorSubject.seeded(AuthState.loading);
  final GoogleSignIn _googleSignIn;
  final String _applicationId;
  final String _serverUrl;
  final String _clientKey;

  ContactAuthApiParse({
    required GoogleSignIn googleSignIn,
    required String applicationId,
    required String serverUrl,
    required String clientKey,
  })  : _googleSignIn = googleSignIn,
        _applicationId = applicationId,
        _serverUrl = serverUrl,
        _clientKey = clientKey {
    _init();
  }

  Future<void> _init() async {
    await Parse().initialize(
      _applicationId,
      _serverUrl,
      clientKey: _clientKey,
      debug: true,
    );

    final user = await ParseUser.currentUser();

    final authState =
        user != null ? AuthState.authenticated : AuthState.unauthenticated;

    _authStateSubject.sink.add(authState);
  }

  @override
  Stream<AuthState> get authState => _authStateSubject.asBroadcastStream();

  @override
  Future<void> loginWithGoogle() async {
    try {
      _authStateSubject.sink.add(AuthState.loading);

      final googleSignInAccount =
          _googleSignIn.currentUser ?? await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        await _signInParseWithGoogle(googleSignInAccount);
        return;
      }

      _authStateSubject.sink.add(AuthState.unauthenticated);
    } catch (e) {
      _authStateSubject.sink.add(AuthState.unauthenticated);
      throw SigninException(
        'Não foi possível fazer login. Tente novamente mais tarde',
      );
    }
  }

  Future<void> _signInParseWithGoogle(
      GoogleSignInAccount googleSignInAccount) async {
    final GoogleSignInAuthentication(:accessToken, :idToken) =
        await googleSignInAccount.authentication;

    final response = await ParseUser.loginWith(
      'google',
      google(accessToken ?? '', googleSignInAccount.id, idToken ?? ''),
    );

    final newAuthState =
        response.success ? AuthState.authenticated : AuthState.unauthenticated;

    _authStateSubject.sink.add(newAuthState);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    (await ParseUser.currentUser())?.logout();
    _authStateSubject.sink.add(AuthState.unauthenticated);
  }
}
